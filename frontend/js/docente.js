const API_URL = 'http://localhost:8000';

document.addEventListener('DOMContentLoaded', async () => {
    const token = localStorage.getItem('upe_token');
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    
    if (!token || !['Professor', 'Coordenador', 'Pesquisador'].includes(userData.role)) {
        alert("🔒 Acesso Restrito a Docentes e Pesquisadores.");
        window.location.href = 'index.html';
        return;
    }

    document.getElementById('docente-name').textContent = `${userData.name} (${userData.role})`;

    document.getElementById('logout-btn').addEventListener('click', () => {
        localStorage.clear();
        window.location.href = 'index.html';
    });

    await carregarVagas(token);

    // Lógica do Modal de Nova Vaga
    const formVaga = document.getElementById('form-nova-vaga');
    if (formVaga) {
        formVaga.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.submitter;
            const textOrig = btn.textContent;
            btn.textContent = "Publicando...";
            btn.disabled = true;

            const payload = {
                titulo: document.getElementById('v_titulo').value,
                descricao: document.getElementById('v_descricao').value,
                data_limite: document.getElementById('v_data_limite').value,
                quantidade_vagas: parseInt(document.getElementById('v_qtd').value),
                id_tipo_vaga: parseInt(document.getElementById('v_tipo').value),
                id_empresa: parseInt(document.getElementById('v_empresa').value)
            };

            try {
                const response = await fetch(`${API_URL}/docente/vagas`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify(payload)
                });
                
                if (!response.ok) throw new Error("Erro ao publicar vaga");
                
                alert("✅ Vaga publicada com sucesso!");
                document.getElementById('modal-vaga').style.display = 'none';
                formVaga.reset();
                carregarVagas(token);
                
            } catch (err) {
                alert("Erro: " + err.message);
            } finally {
                btn.textContent = textOrig;
                btn.disabled = false;
            }
        });
    }
});

async function carregarVagas(token) {
    try {
        const response = await fetch(`${API_URL}/docente/vagas`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error("Erro ao buscar vagas.");

        const vagas = await response.json();
        const tbody = document.getElementById('vagas-tbody');
        tbody.innerHTML = '';
        
        if (vagas.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5">Nenhuma vaga publicada no momento.</td></tr>';
            return;
        }

        vagas.forEach(v => {
            let statusBadge = v.status === 'ABERTA' 
                ? '<span style="background:#10B981; color:white; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Ativo</span>'
                : '<span style="background:#6b7280; color:white; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Inativo</span>';
                
            let tr = document.createElement('tr');
            tr.innerHTML = `
                <td style="color:#6b7280;">#${v.id_vaga}</td>
                <td><strong>${v.titulo}</strong></td>
                <td>${v.quantidade_vagas}</td>
                <td>${v.data_limite || 'Aberto'}</td>
                <td>${statusBadge}</td>
                <td>
                    <button class="btn-primary" style="padding: 6px 12px; font-size: 12px; background-color: var(--upe-blue);" onclick="carregarCandidaturas(${v.id_vaga}, '${token}')">
                        Ver Alunos
                    </button>
                </td>
            `;
            tbody.appendChild(tr);
        });

    } catch (error) {
        console.error(error);
        alert(error.message);
    }
}

window.carregarCandidaturas = async function(id_vaga, token) {
    document.getElementById('painel-candidaturas').style.display = 'block';
    document.getElementById('vaga-ativa-id').textContent = `#${id_vaga}`;
    
    try {
        const response = await fetch(`${API_URL}/docente/vagas/${id_vaga}/candidaturas`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error("Erro ao buscar candidaturas.");
        
        const candidatos = await response.json();
        const tbody = document.getElementById('candidaturas-tbody');
        tbody.innerHTML = '';
        
        if (candidatos.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" style="text-align: center;">Nenhum aluno inscrito ainda.</td></tr>';
            return;
        }

        candidatos.forEach(c => {
            let statusColor = c.status === 'Em análise' ? '#F59E0B' : (c.status === 'Aprovado' ? '#10B981' : '#EF4444');
            let tr = document.createElement('tr');
            tr.innerHTML = `
                <td>
                    <strong>${c.nome}</strong><br>
                    <span style="font-size:12px; color:#6b7280;">${c.email}</span>
                </td>
                <td><span style="color: ${statusColor}; font-weight: 600;">${c.status}</span></td>
                <td>
                    <button class="btn-primary" style="padding: 4px 8px; font-size: 11px; background-color: #10B981;" onclick="mudarStatus(${c.id_candidatura}, 2, ${id_vaga})">Entrevistar</button>
                    <button class="btn-primary" style="padding: 4px 8px; font-size: 11px; background-color: #3B82F6;" onclick="mudarStatus(${c.id_candidatura}, 3, ${id_vaga})">Selecionar</button>
                    <button class="btn-primary" style="padding: 4px 8px; font-size: 11px; background-color: #EF4444;" onclick="mudarStatus(${c.id_candidatura}, 4, ${id_vaga})">Rejeitar</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    } catch(err) {
        console.error(err);
    }
};

window.mudarStatus = async function(id_candidatura, novo_status, id_vaga) {
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/docente/candidaturas/${id_candidatura}/status?novo_status=${novo_status}`, {
            method: 'PUT',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error("Erro ao atualizar status");
        
        carregarCandidaturas(id_vaga, token); // Atualiza a tabela na hora
    } catch(err) {
        alert("Erro: " + err.message);
    }
};
