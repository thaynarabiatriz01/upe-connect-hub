const API_URL = 'http://localhost:8000';

document.addEventListener('DOMContentLoaded', async () => {
    // 1. Verifica se o usuário tem a chave JWT do login
    const token = localStorage.getItem('upe_token');
    if (!token) {
        window.location.href = 'index.html';
        return;
    }

    // 2. Apresenta o nome do usuário na navbar
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    document.getElementById('user-name').textContent = `${userData.name} (${userData.role})`;

    // 3. Lógica do botão de Sair
    document.getElementById('logout-btn').addEventListener('click', () => {
        localStorage.removeItem('upe_token');
        localStorage.removeItem('upe_user');
        window.location.href = 'index.html';
    });

    // 4. Inicia a leitura do banco de dados (vw_vagas_abertas)
    await carregarVagas();
});

async function carregarVagas() {
    const grid = document.getElementById('vagas-grid');
    try {
        const response = await fetch(`${API_URL}/vagas/`);
        const data = await response.json();
        
        if (data.vagas && data.vagas.length > 0) {
            grid.innerHTML = ''; // Limpa a mensagem de carregamento
            data.vagas.forEach(vaga => {
                grid.appendChild(criarCardVaga(vaga));
            });
        } else {
            grid.innerHTML = '<p>Nenhuma vaga disponível no momento.</p>';
        }
    } catch (error) {
        grid.innerHTML = '<p class="error-message">Erro ao buscar vagas. Verifique se o Backend FastAPI está rodando.</p>';
    }
}

function criarCardVaga(vaga) {
    const card = document.createElement('div');
    card.className = 'vaga-card glass-card';
    card.innerHTML = `
        <div class="vaga-header">
            <span class="vaga-tipo">${vaga.tipo_vaga}</span>
            <h3>${vaga.titulo}</h3>
            <p class="vaga-empresa">${vaga.nome_empresa || 'UPE'}</p>
        </div>
        <div class="vaga-body">
            <p>${vaga.descricao.length > 100 ? vaga.descricao.substring(0, 100) + '...' : vaga.descricao}</p>
            <div class="vaga-meta">
                <span>📍 Garanhuns</span>
                <span>📅 Válido até: ${vaga.data_limite ? new Date(vaga.data_limite).toLocaleDateString('pt-BR') : 'Aberto'}</span>
            </div>
        </div>
        <div class="vaga-footer">
            <button class="btn-primary btn-sm" onclick="candidatar(${vaga.id_vaga})">Candidatar-se</button>
        </div>
    `;
    return card;
}

async function candidatar(idVaga) {
    const token = localStorage.getItem('upe_token');
    
    // Decodifica o JWT para descobrir qual é o ID do Aluno logado
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
    
    const tokenData = JSON.parse(jsonPayload);
    
    try {
        // Envia a ordem pro Backend disparar a CALL sp_cadastrar_candidatura()
        const response = await fetch(`${API_URL}/vagas/candidatar`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({ id_usuario: tokenData.id, id_vaga: idVaga })
        });
        
        const data = await response.json();
        
        if (!response.ok) {
            // Esse erro vem direto do 'RAISE EXCEPTION' lá no seu banco PostgreSQL!
            throw new Error(data.detail);
        }
        
        alert("✅ " + (data.message || "Candidatura registrada!"));
    } catch (error) {
        alert("⚠️ ATENÇÃO DO BANCO DE DADOS:\n" + error.message);
    }
}
