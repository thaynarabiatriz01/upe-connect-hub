const API_URL = 'http://localhost:8000';

document.addEventListener('DOMContentLoaded', async () => {
    const token = localStorage.getItem('upe_token');
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    
    if (!token || userData.role !== 'Administrador') {
        alert("🔒 Acesso Restrito: Suas credenciais não possuem privilégios de Administrador de Banco de Dados.");
        window.location.href = 'index.html';
        return;
    }

    document.getElementById('user-name').textContent = `${userData.name} (ROOT)`;

    document.getElementById('logout-btn').addEventListener('click', () => {
        localStorage.clear();
        window.location.href = 'index.html';
    });

    // Event Listeners dos Cards Interativos
    document.getElementById('btn-usuarios-ativos').addEventListener('click', () => carregarTabela('usuarios'));
    document.getElementById('btn-vagas').addEventListener('click', () => carregarTabela('vagas'));
    document.getElementById('btn-candidaturas').addEventListener('click', () => carregarTabela('candidaturas'));
    document.getElementById('btn-eventos').addEventListener('click', () => carregarTabela('eventos'));
    document.getElementById('btn-empresas').addEventListener('click', () => carregarTabela('empresas'));
    document.getElementById('btn-logs').addEventListener('click', () => carregarLogsAuditoria());

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

async function carregarLogsAuditoria() {
    const panel = document.getElementById('dynamic-panel');
    panel.innerHTML = `<p>Buscando histórico na tabela de auditoria...</p>`;
    
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/admin/logs`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error("Erro ao buscar logs");
        const logs = await response.json();
        
        let html = `
            <h3 style="margin-bottom: 20px; color: #4f46e5;">Logs do Sistema / Auditoria</h3>
            <p style="font-size: 14px; color: #6b7280; margin-bottom: 20px;">Histórico de todas as operações nas principais tabelas do banco.</p>
            <div style="overflow-x: auto;">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Data</th>
                            <th>Autor</th>
                            <th>Cargo</th>
                            <th>Tabela Afetada</th>
                            <th>Ação</th>
                        </tr>
                    </thead>
                    <tbody>
        `;
        
        if (logs.length === 0) {
            html += `<tr><td colspan="5" style="text-align:center;">Nenhum registro de log encontrado.</td></tr>`;
        } else {
            logs.forEach(l => {
                const dataFormatada = new Date(l.data_registro).toLocaleString('pt-BR');
                const operacaoCor = l.operacao === 'INSERT' ? '#10b981' : (l.operacao === 'UPDATE' ? '#f59e0b' : '#ef4444');
                html += `
                    <tr>
                        <td>${dataFormatada}</td>
                        <td style="font-weight: 500;">${l.nome_usuario || 'Sistema/Desconhecido'} (ID: ${l.id_usuario || '?'})</td>
                        <td><span class="status-badge" style="background:#e5e7eb;color:#374151;">${l.tipo_usuario || 'N/A'}</span></td>
                        <td><code>${l.tabela_afetada}</code></td>
                        <td><span style="color: ${operacaoCor}; font-weight: bold;">${l.operacao}</span></td>
                    </tr>
                `;
            });
        }
        
        html += `</tbody></table></div>`;
        panel.innerHTML = html;
        
    } catch (error) {
        panel.innerHTML = `<p style="color:red;">Erro ao processar a auditoria: ${error.message}</p>`;
    }
}

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
        } else if (tipo === 'empresas') {
            endpoint = '/empresas/';
            renderFunc = renderEmpresas;
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
                    <th>Ações</th>
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
            <td>
                <button class="btn-primary" style="padding: 4px 8px; font-size: 11px; background-color: #F59E0B;" onclick="abrirModalEditarAdmin(${d.id_vaga}, '${d.titulo}', '', '${d.data_fim}', ${d.bolsa}, 1)">✏️</button>
                <button class="btn-primary" style="padding: 4px 8px; font-size: 11px; background-color: #EF4444;" onclick="excluirVagaAdmin(${d.id_vaga})">🗑️</button>
            </td>
        </tr>`;
    });
    return html + '</tbody></table>';
}

// === LÓGICA DE EXCLUSÃO (ADMIN) ===
window.excluirVagaAdmin = async function(id_vaga) {
    if (!confirm(`MODO ADMIN: Tem certeza que deseja forçar a exclusão da Vaga #${id_vaga}?`)) return;
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/admin/vagas/${id_vaga}`, {
            method: 'DELETE',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (!response.ok) throw new Error(await response.text());
        
        alert("✅ Vaga excluída pelo Administrador.");
        carregarVagas();
    } catch(err) {
        alert("Erro: " + err.message);
    }
};

// === LÓGICA DE EDIÇÃO (ADMIN) ===
let vagaEmEdicaoAdmin = null;

window.abrirModalEditarAdmin = function(id_vaga, titulo, descricao, data_limite, qtd, tipo) {
    vagaEmEdicaoAdmin = id_vaga;
    document.getElementById('v_titulo').value = titulo;
    document.getElementById('v_descricao').value = descricao;
    document.getElementById('v_data_limite').value = data_limite;
    document.getElementById('v_qtd').value = qtd;
    document.getElementById('v_tipo').value = tipo;
    
    document.getElementById('modal-vaga').style.display = 'flex';
};

document.addEventListener('DOMContentLoaded', () => {
    const formVaga = document.getElementById('form-nova-vaga');
    if (formVaga) {
        formVaga.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.submitter;
            btn.textContent = "Salvando...";
            btn.disabled = true;

            const payload = {
                titulo: document.getElementById('v_titulo').value,
                descricao: document.getElementById('v_descricao').value,
                data_limite: document.getElementById('v_data_limite').value,
                quantidade_vagas: parseInt(document.getElementById('v_qtd').value),
                id_tipo_vaga: parseInt(document.getElementById('v_tipo').value)
            };

            const token = localStorage.getItem('upe_token');
            try {
                const response = await fetch(`${API_URL}/admin/vagas/${vagaEmEdicaoAdmin}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify(payload)
                });
                
                if (!response.ok) throw new Error(await response.text());
                
                alert("✅ Vaga atualizada pelo Administrador!");
                document.getElementById('modal-vaga').style.display = 'none';
                formVaga.reset();
                vagaEmEdicaoAdmin = null;
                carregarVagas();
                
            } catch (err) {
                alert("Erro: " + err.message);
            } finally {
                btn.textContent = "Salvar Alterações";
                btn.disabled = false;
            }
        });
    }
});

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

function renderEmpresas(dados) {
    let html = `
        <h3 style="margin-bottom: 20px; color: var(--upe-blue);">Gestão de Empresas Parceiras</h3>
        <p style="font-size: 14px; color: #6b7280; margin-bottom: 25px;">
            Cadastre novas empresas e seus respectivos representantes comerciais para disponibilização de vagas.
        </p>

        <!-- Formulário de Nova Empresa -->
        <div style="background: #f9fafb; padding: 20px; border-radius: 12px; border: 1px solid #e5e7eb; margin-bottom: 30px; color: black; text-align: left;">
            <h4 style="margin: 0 0 15px 0; color: #374151;">Cadastrar Nova Empresa</h4>
            <form id="form-cadastrar-empresa" onsubmit="cadastrarEmpresaAdmin(event)" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">Razão Social</label>
                    <input type="text" id="emp_razao" required style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">Nome Fantasia</label>
                    <input type="text" id="emp_nome" required style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">CNPJ</label>
                    <input type="text" id="emp_cnpj" required placeholder="00.000.000/0000-00" style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">E-mail Corporativo</label>
                    <input type="email" id="emp_email" required style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">Telefone</label>
                    <input type="text" id="emp_tel" required placeholder="(87) 99999-9999" style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">Site (Opcional)</label>
                    <input type="url" id="emp_site" placeholder="https://..." style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                
                <!-- Dados do Representante -->
                <div style="grid-column: 1 / -1; margin-top: 10px; border-top: 1px solid #e5e7eb; padding-top: 15px;">
                    <h5 style="margin: 0 0 10px 0; color: #4b5563; font-weight: bold;">Dados do Representante Legal</h5>
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">Nome Representante</label>
                    <input type="text" id="rep_nome" required style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">E-mail do Representante</label>
                    <input type="email" id="rep_email" required style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">Telefone do Representante</label>
                    <input type="text" id="rep_tel" required style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:600; color:#4b5563;">Cargo do Representante</label>
                    <input type="text" id="rep_cargo" required placeholder="Ex: Diretor de RH" style="width:100%; padding: 8px; border:1px solid #d1d5db; border-radius:6px; font-size:13px;">
                </div>
                
                <div style="grid-column: 1 / -1; text-align: right; margin-top: 15px;">
                    <button type="submit" class="btn-primary" style="width: 200px; background-color: #10b981;">Cadastrar Empresa</button>
                </div>
            </form>
        </div>

        <h4 style="margin-bottom: 15px; color: #374151;">Empresas Cadastradas</h4>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome Fantasia / Razão Social</th>
                    <th>CNPJ</th>
                    <th>E-mail</th>
                    <th>Telefone</th>
                    <th>Site</th>
                </tr>
            </thead>
            <tbody>
    `;

    if (dados.length === 0) {
        html += `<tr><td colspan="6" style="text-align: center;">Nenhuma empresa cadastrada.</td></tr>`;
    } else {
        dados.forEach(d => {
            html += `<tr>
                <td style="color:#6b7280;">#${d.id_empresa}</td>
                <td><strong>${d.nome_empresa}</strong><br><span style="font-size:11px;color:#9ca3af;">${d.razao_social}</span></td>
                <td>${d.cnpj}</td>
                <td>${d.email}</td>
                <td>${d.telefone}</td>
                <td><a href="${d.site || '#'}" target="_blank" style="color: #3b82f6;">${d.site || 'N/A'}</a></td>
            </tr>`;
        });
    }

    return html + '</tbody></table>';
}

window.cadastrarEmpresaAdmin = async function(event) {
    event.preventDefault();
    const token = localStorage.getItem('upe_token');
    
    const payload = {
        razao_social: document.getElementById('emp_razao').value,
        nome_empresa: document.getElementById('emp_nome').value,
        cnpj: document.getElementById('emp_cnpj').value,
        email: document.getElementById('emp_email').value,
        telefone: document.getElementById('emp_tel').value,
        site: document.getElementById('emp_site').value || null,
        nome_representante: document.getElementById('rep_nome').value,
        email_representante: document.getElementById('rep_email').value,
        telefone_representante: document.getElementById('rep_tel').value,
        cargo_representante: document.getElementById('rep_cargo').value
    };
    
    try {
        const response = await fetch(`${API_URL}/empresas/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify(payload)
        });
        
        if (!response.ok) {
            const err = await response.json();
            throw new Error(err.detail || "Erro ao cadastrar empresa");
        }
        
        alert("✅ Empresa e Representante cadastrados com sucesso!");
        carregarTabela('empresas'); // Recarrega a tabela de empresas
    } catch (err) {
        alert("Erro: " + err.message);
    }
};
