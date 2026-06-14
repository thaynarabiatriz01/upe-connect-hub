const API_URL = 'http://localhost:8000';

document.addEventListener('DOMContentLoaded', async () => {
    const token = localStorage.getItem('upe_token');
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    
    if (!token || userData.role !== 'Administrador') {
        alert("🔒 Acesso Restrito: Suas credenciais não possuem privilégios de Administrador de Banco de Dados.");
        window.location.href = 'index.html';
        return;
    }

    document.getElementById('admin-name').textContent = `${userData.name} (ROOT)`;

    document.getElementById('logout-btn').addEventListener('click', () => {
        localStorage.clear();
        window.location.href = 'index.html';
    });

    // Event Listeners dos Cards Interativos
    document.getElementById('btn-usuarios-ativos').addEventListener('click', () => carregarTabela('usuarios'));
    document.getElementById('btn-vagas').addEventListener('click', () => carregarTabela('vagas'));
    document.getElementById('btn-candidaturas').addEventListener('click', () => carregarTabela('candidaturas'));
    document.getElementById('btn-eventos').addEventListener('click', () => carregarTabela('eventos'));

    // Carrega dashboard principal e exibe aprovações pendentes por padrão
    await carregarDashboardAdmin(token);
});

async function carregarDashboardAdmin(token) {
    try {
        const response = await fetch(`${API_URL}/admin/dashboard`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error("Erro de comunicação com o PostgreSQL.");

        const data = await response.json();
        
        document.getElementById('stat-usuarios').textContent = data.stats.usuarios;
        document.getElementById('stat-vagas').textContent = data.stats.vagas;
        document.getElementById('stat-candidaturas').textContent = data.stats.candidaturas;
        document.getElementById('stat-eventos').textContent = data.stats.eventos;
        
        // Renderiza a tabela padrão (Pendentes)
        renderTabelaPendentes(data.usuarios_pendentes);

    } catch (error) {
        console.error(error);
    }
}

// ==========================================
// RENDERIZAÇÃO DINÂMICA DE TABELAS
// ==========================================

function renderTabelaPendentes(usuarios) {
    const panel = document.getElementById('dynamic-panel');
    let html = `
        <h3 style="margin-bottom: 20px; color: var(--upe-red);">Aprovações Pendentes</h3>
        <p style="font-size: 14px; color: #6b7280; margin-bottom: 20px;">
            As contas abaixo foram criadas através do formulário de autocadastro e estão inativas (<code>ativo = FALSE</code>). Avalie e valide os usuários para liberar o acesso ao sistema.
        </p>
        <div style="overflow-x: auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID Banco</th>
                        <th>Nome de Usuário</th>
                        <th>E-mail Corporativo</th>
                        <th>Cargo Solicitado</th>
                        <th>Ação Administrativa</th>
                    </tr>
                </thead>
                <tbody>
    `;

    if (usuarios.length === 0) {
        html += `<tr><td colspan="5" style="text-align: center; color: #10B981;">🎉 Nenhuma aprovação pendente no momento!</td></tr>`;
    } else {
        usuarios.forEach(u => {
            html += `
                <tr>
                    <td style="font-family: monospace; color: #6b7280;">#${u.id_usuario}</td>
                    <td><strong>${u.nome}</strong></td>
                    <td>${u.email}</td>
                    <td><span class="badge-role">${u.nome_tipo}</span></td>
                    <td>
                        <button class="btn-primary" style="padding: 6px 12px; font-size: 12px; background-color: #10B981;" onclick="aprovarUsuario(${u.id_usuario})">
                            ✅ Aprovar
                        </button>
                    </td>
                </tr>
            `;
        });
    }

    html += `</tbody></table></div>`;
    panel.innerHTML = html;
}

async function carregarTabela(tipo) {
    const panel = document.getElementById('dynamic-panel');
    panel.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--text-light);">Carregando dados do banco...</div>';
    
    const token = localStorage.getItem('upe_token');
    
    try {
        let endpoint = '';
        let renderFunc = null;
        
        if (tipo === 'usuarios') {
            endpoint = '/admin/usuarios/ativos';
            renderFunc = renderUsuariosAtivos;
        } else if (tipo === 'vagas') {
            endpoint = '/admin/vagas_detalhes';
            renderFunc = renderVagas;
        } else if (tipo === 'candidaturas') {
            endpoint = '/admin/candidaturas_detalhes';
            renderFunc = renderCandidaturas;
        } else if (tipo === 'eventos') {
            endpoint = '/admin/eventos_detalhes';
            renderFunc = renderEventos;
        }

        const response = await fetch(`${API_URL}${endpoint}`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error(`Falha ao buscar ${tipo}`);
        
        const data = await response.json();
        panel.innerHTML = renderFunc(data);
        
        // Adicionar botão para voltar às aprovações
        panel.innerHTML += `
            <div style="margin-top: 20px; text-align: right;">
                <button class="btn-primary" style="background-color: #6b7280;" onclick="carregarDashboardAdmin('${token}')">Voltar para Aprovações Pendentes</button>
            </div>
        `;

    } catch (error) {
        panel.innerHTML = `<div style="color: red;">Erro: ${error.message}</div>`;
    }
}

function renderUsuariosAtivos(dados) {
    let html = `
        <h3 style="margin-bottom: 20px; color: var(--upe-blue);">Usuários Ativos no Sistema</h3>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>E-mail</th>
                    <th>Telefone</th>
                    <th>Tipo</th>
                </tr>
            </thead>
            <tbody>
    `;
    dados.forEach(d => {
        html += `<tr>
            <td style="color:#6b7280;">#${d.id_usuario}</td>
            <td><strong>${d.nome}</strong></td>
            <td>${d.email}</td>
            <td>${d.telefone}</td>
            <td><span class="badge-role">${d.nome_tipo}</span></td>
        </tr>`;
    });
    return html + '</tbody></table>';
}

function renderVagas(dados) {
    let html = `
        <h3 style="margin-bottom: 20px; color: var(--upe-blue);">Vagas Publicadas</h3>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Título da Vaga</th>
                    <th>Empresa</th>
                    <th>Qtd. Vagas</th>
                    <th>Data Fim</th>
                </tr>
            </thead>
            <tbody>
    `;
    dados.forEach(d => {
        html += `<tr>
            <td style="color:#6b7280;">#${d.id_vaga}</td>
            <td><strong>${d.titulo}</strong></td>
            <td>${d.empresa}</td>
            <td>${d.bolsa} vaga(s)</td>
            <td>${d.data_fim || 'Não definida'}</td>
        </tr>`;
    });
    return html + '</tbody></table>';
}

function renderCandidaturas(dados) {
    let html = `
        <h3 style="margin-bottom: 20px; color: var(--upe-blue);">Histórico de Candidaturas</h3>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Aluno</th>
                    <th>Vaga</th>
                    <th>Status Atual</th>
                    <th>Data Candidatura</th>
                </tr>
            </thead>
            <tbody>
    `;
    dados.forEach(d => {
        let statusColor = d.status === 'Em análise' ? '#F59E0B' : (d.status === 'Aprovado' ? '#10B981' : '#EF4444');
        html += `<tr>
            <td style="color:#6b7280;">#${d.id_candidatura}</td>
            <td><strong>${d.aluno}</strong></td>
            <td>${d.vaga}</td>
            <td><span style="color: ${statusColor}; font-weight: 600;">${d.status}</span></td>
            <td>${d.data_candidatura}</td>
        </tr>`;
    });
    return html + '</tbody></table>';
}

function renderEventos(dados) {
    let html = `
        <h3 style="margin-bottom: 20px; color: var(--upe-blue);">Eventos Acadêmicos</h3>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Título do Evento</th>
                    <th>Local</th>
                    <th>Data/Hora Início</th>
                    <th>Vagas Totais</th>
                </tr>
            </thead>
            <tbody>
    `;
    dados.forEach(d => {
        html += `<tr>
            <td style="color:#6b7280;">#${d.id_evento}</td>
            <td><strong>${d.titulo}</strong></td>
            <td>${d.local}</td>
            <td>${d.data_inicio}</td>
            <td>${d.vagas} vagas</td>
        </tr>`;
    });
    return html + '</tbody></table>';
}

window.aprovarUsuario = async function(id_usuario) {
    if(!confirm("Tem certeza que deseja ativar este usuário no banco de dados?")) return;

    const token = localStorage.getItem('upe_token');
    
    try {
        const response = await fetch(`${API_URL}/admin/usuarios/${id_usuario}/aprovar`, {
            method: 'PUT',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        const data = await response.json();
        if (!response.ok) throw new Error(data.detail);
        
        alert("✅ " + data.message);
        carregarDashboardAdmin(token);
        
    } catch (error) {
        alert("❌ Erro DB: " + error.message);
    }
};
