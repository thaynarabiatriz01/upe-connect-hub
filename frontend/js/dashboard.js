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
    
    // Verifica papel do usuário atual
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    const role = userData.role || '';
    const proibidos = ["Professor", "Coordenador", "Pesquisador", "Administrador"];
    const showButton = !proibidos.includes(role);
    
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
            ${showButton ? `<button class="btn-primary btn-sm" onclick="candidatar(${vaga.id_vaga})">Candidatar-se</button>` : `<span style="font-size: 12px; color: #6b7280; font-style: italic;">Você já está atuando como docente/admin</span>`}
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

// ----------------------------------------
// Lógica de Notificações
// ----------------------------------------

document.addEventListener('DOMContentLoaded', () => {
    const bellContainer = document.getElementById('bell-container');
    const notifDropdown = document.getElementById('notif-dropdown');
    
    if (bellContainer && notifDropdown) {
        bellContainer.addEventListener('click', (e) => {
            // Previne propagação para que o clique fora funcione
            e.stopPropagation();
            if (notifDropdown.style.display === 'none' || notifDropdown.style.display === '') {
                notifDropdown.style.display = 'block';
                carregarNotificacoes();
            } else {
                notifDropdown.style.display = 'none';
            }
        });

        // Fechar se clicar fora
        document.addEventListener('click', (e) => {
            if (!bellContainer.contains(e.target)) {
                notifDropdown.style.display = 'none';
            }
        });
    }
    
    // Carrega badge inicialmente
    carregarNotificacoes(true);
});

async function carregarNotificacoes(silencioso = false) {
    const token = localStorage.getItem('upe_token');
    if (!token) return;
    
    const itemsDiv = document.getElementById('notif-items');
    const countBadge = document.getElementById('notif-count');
    
    try {
        const response = await fetch(`${API_URL}/usuarios/notificacoes`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (response.status === 401) {
            if (!silencioso) {
                alert("Sessão expirada. Por favor, faça login novamente.");
                localStorage.clear();
                window.location.href = 'index.html';
            }
            return;
        }
        
        if (!response.ok) {
            if (!silencioso) itemsDiv.innerHTML = '<p style="text-align: center; padding: 15px; color:red; font-size:12px;">Erro ao carregar notificações.</p>';
            return;
        }
        
        const data = await response.json();
        
        // Conta as não lidas
        const naoLidas = data.filter(n => !n.lida).length;
        if (countBadge) {
            if (naoLidas > 0) {
                countBadge.textContent = naoLidas;
                countBadge.style.display = 'inline-block';
            } else {
                countBadge.style.display = 'none';
            }
        }
        
        if (!silencioso && itemsDiv) {
            itemsDiv.innerHTML = '';
            if (data.length === 0) {
                itemsDiv.innerHTML = '<p style="text-align: center; padding: 15px; color:#6b7280; font-size:12px;">Você não possui nenhuma notificação.</p>';
                return;
            }
            
            data.forEach(n => {
                const item = document.createElement('div');
                item.className = 'notif-item ' + (n.lida ? '' : 'notif-unread');
                item.style.padding = '12px 16px';
                item.style.borderBottom = '1px solid #f3f4f6';
                item.style.cursor = 'pointer';
                
                item.innerHTML = `
                    <div style="display:flex; justify-content:space-between; margin-bottom:5px;">
                        <strong style="color:#1e3a8a;">${n.titulo}</strong>
                        <span style="font-size:10px; color:#9ca3af;">${n.data_criacao}</span>
                    </div>
                    <p style="margin:0; color:#4b5563;">${n.mensagem}</p>
                `;
                
                item.addEventListener('click', async () => {
                    if (!n.lida) {
                        try {
                            await fetch(`${API_URL}/usuarios/notificacoes/${n.id_notificacao}/ler`, {
                                method: 'PUT',
                                headers: { 'Authorization': `Bearer ${token}` }
                            });
                            // Atualiza a visualização
                            carregarNotificacoes(true); // badge update
                            item.classList.remove('notif-unread');
                            n.lida = true;
                        } catch (err) {}
                    }
                });
                itemsDiv.appendChild(item);
            });
        }
        
    } catch (error) {
        if (!silencioso && itemsDiv) {
            itemsDiv.innerHTML = '<p style="text-align: center; padding: 15px; color:red; font-size:12px;">Falha de comunicação.</p>';
        }
    }
}

// ----------------------------------------
// Lógica de Candidaturas do Aluno
// ----------------------------------------

window.carregarCandidaturas = async function() {
    const lista = document.getElementById('candidaturas-lista');
    const token = localStorage.getItem('upe_token');
    if (!token) return;
    
    try {
        const response = await fetch(`${API_URL}/usuarios/minhas_candidaturas`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) {
            lista.innerHTML = '<p class="error-message" style="color:red;">Erro ao buscar candidaturas.</p>';
            return;
        }
        
        const data = await response.json();
        lista.innerHTML = '';
        
        if (data.length === 0) {
            lista.innerHTML = '<p>Você ainda não se candidatou a nenhuma vaga.</p>';
            return;
        }
        
        data.forEach(cand => {
            const card = document.createElement('div');
            card.className = 'candidatura-card';
            
            // Define cor do badge baseado no status
            let corFundo = '#e0e7ff';
            let corTexto = '#4f46e5';
            if (cand.status.includes('Pendente')) { corFundo = '#fef3c7'; corTexto = '#d97706'; }
            else if (cand.status.includes('Selecionado')) { corFundo = '#d1fae5'; corTexto = '#059669'; }
            else if (cand.status.includes('Rejeitado')) { corFundo = '#fee2e2'; corTexto = '#dc2626'; }
            else if (cand.status.includes('Entrevista')) { corFundo = '#e0e7ff'; corTexto = '#4f46e5'; }

            card.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                        <h3 style="margin:0; color:#1e3a8a;">${cand.vaga}</h3>
                        <p style="margin:5px 0; font-size:14px; color:#6b7280;">${cand.empresa || 'UPE'} • Candidatou em: ${cand.data_candidatura}</p>
                    </div>
                    <span style="padding:4px 8px; border-radius:12px; font-size:12px; font-weight:bold; background:${corFundo}; color:${corTexto};">
                        ${cand.status}
                    </span>
                </div>
                ${cand.feedback ? `
                <div style="margin-top:10px; padding:10px; background:#f9fafb; border-radius:8px; border-left:3px solid #9ca3af;">
                    <p style="margin:0; font-size:13px; color:#4b5563;"><strong>Feedback:</strong> ${cand.feedback}</p>
                    <p style="margin:0; font-size:11px; color:#9ca3af; margin-top:5px;">${cand.data_feedback}</p>
                </div>` : ''}
                <div style="margin-top:15px; display:flex; gap:10px;">
                    <button class="btn-primary" style="padding:6px 12px; font-size:12px; border-radius:6px; background-color:var(--upe-blue); color:white; border:none; cursor:pointer;" onclick="abrirDetalhesVaga(${cand.id_vaga})">Ver Detalhes</button>
                    <button class="btn-primary" style="padding:6px 12px; font-size:12px; border-radius:6px; background-color:transparent; color:#ef4444; border:1px solid #ef4444; cursor:pointer;" onclick="cancelarCandidatura(${cand.id_candidatura})">Desistir da Vaga</button>
                </div>
            `;
            lista.appendChild(card);
        });
        
    } catch (error) {
        lista.innerHTML = '<p class="error-message" style="color:red;">Falha na comunicação com o servidor.</p>';
    }
}

// Abre Modal com os detalhes de uma Vaga
window.abrirDetalhesVaga = async function(id_vaga) {
    const conteudo = document.getElementById('modal-vaga-conteudo');
    const modal = document.getElementById('modal-vaga');
    
    conteudo.innerHTML = '<p>Buscando detalhes no servidor...</p>';
    modal.style.display = 'flex';
    
    try {
        const response = await fetch(`${API_URL}/vagas/${id_vaga}`);
        if (!response.ok) {
            conteudo.innerHTML = '<p style="color:red;">Erro ao carregar detalhes da vaga.</p>';
            return;
        }
        const vaga = await response.json();
        
        // Monta os badges de habilidades e requisitos
        const habsHTML = vaga.habilidades && vaga.habilidades.length > 0 
            ? vaga.habilidades.map(h => `<span style="background:#e0e7ff; color:#4f46e5; padding:3px 8px; border-radius:12px; font-size:11px; margin-right:5px; display:inline-block;">${h.nome}</span>`).join('') 
            : '<span style="font-size:13px; color:#9ca3af;">Não exigido</span>';
            
        const reqsHTML = vaga.requisitos && vaga.requisitos.length > 0 
            ? vaga.requisitos.map(r => `<li style="font-size:13px; color:#4b5563;">${r}</li>`).join('') 
            : '<span style="font-size:13px; color:#9ca3af;">Sem requisitos específicos</span>';

        conteudo.innerHTML = `
            <div style="margin-bottom: 15px;">
                <span style="font-size: 12px; color: #6b7280; font-weight: bold;">${vaga.tipo_vaga}</span>
                <h3 style="margin: 5px 0; color: #111827;">${vaga.titulo}</h3>
                <p style="margin: 0; color: #4b5563; font-size: 14px;"><strong>Empresa:</strong> ${vaga.nome_empresa || 'UPE'}</p>
            </div>
            <div style="margin-bottom: 15px;">
                <h4 style="margin: 0 0 5px 0; color: #374151; font-size: 14px;">Descrição</h4>
                <p style="margin: 0; font-size: 14px; color: #4b5563; line-height: 1.5;">${vaga.descricao}</p>
            </div>
            <div style="margin-bottom: 15px;">
                <h4 style="margin: 0 0 5px 0; color: #374151; font-size: 14px;">Requisitos</h4>
                <ul style="margin: 0; padding-left: 20px;">
                    ${reqsHTML}
                </ul>
            </div>
            <div style="margin-bottom: 15px;">
                <h4 style="margin: 0 0 5px 0; color: #374151; font-size: 14px;">Habilidades Recomendadas</h4>
                <div style="margin-top: 5px;">${habsHTML}</div>
            </div>
            <div>
                <p style="margin: 0; font-size: 13px; color: #6b7280;"><strong>Quantidade de Vagas:</strong> ${vaga.quantidade_vagas || 1}</p>
                <p style="margin: 5px 0 0 0; font-size: 13px; color: #6b7280;"><strong>Prazo de Inscrição:</strong> ${vaga.data_limite ? new Date(vaga.data_limite).toLocaleDateString('pt-BR') : 'Aberto'}</p>
            </div>
        `;
    } catch (error) {
        conteudo.innerHTML = '<p style="color:red;">Falha de conexão com a API.</p>';
    }
}

// Cancela a inscrição em uma vaga
window.cancelarCandidatura = async function(id_candidatura) {
    if (!confirm('Você tem certeza que deseja desistir dessa vaga? Essa ação não pode ser desfeita e você perderá seu lugar na fila.')) {
        return;
    }
    
    const token = localStorage.getItem('upe_token');
    if (!token) return;

    try {
        const response = await fetch(`${API_URL}/usuarios/minhas_candidaturas/${id_candidatura}`, {
            method: 'DELETE',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) {
            const data = await response.json();
            alert("Erro ao cancelar: " + (data.detail || "Tente novamente."));
            return;
        }
        
        alert("Sua candidatura foi cancelada com sucesso!");
        carregarCandidaturas(); // Atualiza a tela após cancelar
        
    } catch (error) {
        alert("Erro de conexão ao tentar cancelar a candidatura.");
    }
}

