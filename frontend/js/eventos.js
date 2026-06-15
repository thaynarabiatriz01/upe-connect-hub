const API_URL = 'http://localhost:8000';

document.addEventListener('DOMContentLoaded', async () => {
    const token = localStorage.getItem('upe_token');
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    
    if (!token) {
        window.location.href = 'index.html';
        return;
    }

    document.getElementById('user-name').textContent = `${userData.name} (${userData.role})`;

    document.getElementById('btn-voltar').addEventListener('click', () => {
        if (userData.role === 'Administrador') window.location.href = 'admin.html';
        else if (userData.role === 'Professor') window.location.href = 'professor.html';
        else if (userData.role === 'Pesquisador') window.location.href = 'pesquisador.html';
        else if (userData.role === 'Monitor') window.location.href = 'monitor.html';
        else window.location.href = 'dashboard.html';
    });

    document.getElementById('logout-btn').addEventListener('click', () => {
        localStorage.clear();
        window.location.href = 'index.html';
    });

    if (['Professor', 'Coordenador', 'Pesquisador', 'Administrador'].includes(userData.role)) {
        document.getElementById('btn-tab-gestao').style.display = 'inline-block';
        
        // Carrega as opções de papéis (tipos de usuário) cadastrados no banco
        try {
            const res = await fetch(`${API_URL}/usuarios/tipos_usuario`);
            if (res.ok) {
                const papeis = await res.json();
                const papelSelect = document.getElementById('eq_papel');
                if (papelSelect) {
                    papelSelect.innerHTML = '<option value="">Selecione...</option>';
                    papeis.forEach(p => {
                        const opt = document.createElement('option');
                        opt.value = p.nome_tipo;
                        opt.textContent = p.nome_tipo;
                        papelSelect.appendChild(opt);
                    });
                    // Define 'Monitor' como selecionado por padrão
                    const monitorOpt = Array.from(papelSelect.options).find(o => o.value === 'Monitor');
                    if (monitorOpt) monitorOpt.selected = true;
                }
            }
        } catch (err) {
            console.error("Erro ao carregar papéis", err);
        }
    }

    await carregarEventos();

    const formCriar = document.getElementById('form-criar-evento');
    if (formCriar) {
        formCriar.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.submitter;
            btn.textContent = 'Publicando...';
            btn.disabled = true;

            const payload = {
                titulo: document.getElementById('ev_titulo').value,
                descricao: document.getElementById('ev_descricao').value,
                data_inicio: document.getElementById('ev_inicio').value.replace('T', ' '),
                data_fim: document.getElementById('ev_fim').value.replace('T', ' '),
                local: document.getElementById('ev_local').value,
                vagas: document.getElementById('ev_vagas').value,
                carga_horaria: parseInt(document.getElementById('ev_carga').value)
            };

            try {
                const response = await fetch(`${API_URL}/eventos/`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) throw new Error("Erro ao criar evento");
                alert("✅ Evento publicado com sucesso!");
                formCriar.reset();
                carregarEventos();
                showTab('tab-proximos', document.querySelector('.tab-btn'));
            } catch(err) {
                alert(err.message);
            } finally {
                btn.textContent = 'Publicar Evento';
                btn.disabled = false;
            }
        });
    }
    const formEquipe = document.getElementById('form-alocar-monitor');
    if (formEquipe) {
        formEquipe.addEventListener('submit', async (e) => {
            e.preventDefault();
            const btn = e.submitter;
            btn.textContent = 'Adicionando...';
            btn.disabled = true;

            const id_evento = document.getElementById('eq_id_evento').value;
            const payload = {
                email_aluno: document.getElementById('eq_email').value,
                papel: document.getElementById('eq_papel').value
            };

            try {
                const response = await fetch(`${API_URL}/eventos/${id_evento}/equipe`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${token}`
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) {
                    const err = await response.json();
                    throw new Error(err.detail);
                }
                const data = await response.json();
                alert(`✅ ${data.message}`);
                formEquipe.reset();
            } catch(err) {
                alert(`Erro: ${err.message}`);
            } finally {
                btn.textContent = 'Adicionar';
                btn.disabled = false;
            }
        });
    }
});

async function carregarEventos() {
    try {
        const response = await fetch(`${API_URL}/eventos/`);
        const lista = document.getElementById('lista-eventos');
        lista.innerHTML = '';
        
        if (response.ok) {
            const eventos = await response.json();
            if(eventos.length === 0) {
                lista.innerHTML = '<p style="text-align: center; color: #6b7280; margin-top: 40px;">Nenhum evento com inscrições abertas no momento.</p>';
                return;
            }

            const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
            const role = userData.role || '';
            const proibidos = ["Professor", "Coordenador", "Pesquisador", "Administrador"];
            const showButton = !proibidos.includes(role);

            eventos.forEach(ev => {
                const card = document.createElement('div');
                card.className = 'evento-card';
                card.innerHTML = `
                    <h3>${ev.titulo} <span style="font-size: 12px; color: #9ca3af; font-weight: 400;">#${ev.id_evento}</span></h3>
                    <div class="evento-meta">
                        <span>🗓️ Início: ${ev.data_inicio}</span>
                        <span>📍 Local: ${ev.local}</span>
                        <span>⏱️ Carga: ${ev.carga_horaria}h</span>
                        <span>👥 Vagas: ${ev.vagas}</span>
                    </div>
                    <p style="color: #4b5563; margin-bottom: 20px; font-size: 15px;">${ev.descricao}</p>
                    ${showButton ? `<button class="btn-primary" onclick="participarEvento(${ev.id_evento})" style="background-color: #10B981; width: auto; padding: 8px 20px;">Realizar Inscrição</button>` : `<span style="font-size: 12px; color: #6b7280; font-style: italic;">Apenas estudantes podem se inscrever.</span>`}
                `;
                lista.appendChild(card);
            });
        }
    } catch(err) {
        console.error(err);
    }
}

window.participarEvento = async function(id_evento) {
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/eventos/${id_evento}/participar`, {
            method: 'POST',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if(response.ok) {
            alert("✅ Inscrição confirmada com sucesso!");
        } else {
            const err = await response.json();
            alert("Aviso: " + err.detail);
        }
    } catch(err) {
        alert("Erro de comunicação ao se inscrever.");
    }
}

window.gerarCertificados = async function() {
    const id_evento = document.getElementById('ev_id_cert').value;
    if(!id_evento) return alert("Por favor, informe o ID do Evento!");
    
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/eventos/${id_evento}/certificados`, {
            method: 'POST',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if(response.ok) {
            const data = await response.json();
            alert("✅ " + data.message + "\n(Estes dados foram populados na tabela certificados).");
        } else {
            const err = await response.json();
            alert("Erro: " + err.detail);
        }
    } catch(err) {
        alert("Erro ao processar chamada à API.");
    }
}

window.showTab = function(tabId, btn) {
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    btn.classList.add('active');
    
    if (tabId === 'tab-meus') {
        carregarMinhasInscricoes();
    }
};

async function carregarMinhasInscricoes() {
    const token = localStorage.getItem('upe_token');
    const list = document.getElementById('minhas-inscricoes-lista');
    try {
        const response = await fetch(`${API_URL}/eventos/minhas_inscricoes`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        
        if (response.status === 401) {
            alert("Sessão expirada. Por favor, faça login novamente.");
            localStorage.clear();
            window.location.href = 'index.html';
            return;
        }
        
        if (!response.ok) {
            const errText = await response.text();
            throw new Error(`Erro ao buscar inscrições. Status: ${response.status}.`);
        }
        
        const data = await response.json();
        list.innerHTML = '';
        
        if (data.length === 0) {
            list.innerHTML = '<p style="text-align: center; color: #6b7280; margin-top: 40px;">Você ainda não se inscreveu em nenhum evento.</p>';
            return;
        }
        
        data.forEach(ins => {
            const card = document.createElement('div');
            card.className = 'evento-card';
            
            let certificadoBtn = '';
            if (ins.presenca && ins.codigo_validacao) {
                certificadoBtn = `
                    <button class="btn-primary" onclick="abrirCertificado('${ins.titulo}', '${ins.carga_horaria}', '${ins.codigo_validacao}', '${ins.data_emissao}', '${ins.tipo_participacao}')" style="background-color: #F59E0B; width: auto; padding: 8px 20px; margin-top: 15px;">
                        📜 Visualizar Certificado
                    </button>
                `;
            } else if (ins.presenca) {
                certificadoBtn = `<span style="display:inline-block; margin-top:15px; color:#10B981; font-weight:600; font-size:13px;">✓ Presença Confirmada (Aguardando liberação de certificado)</span>`;
            } else {
                certificadoBtn = `<span style="display:inline-block; margin-top:15px; color:#6b7280; font-size:13px;">⌛ Presença pendente / Evento não realizado</span>`;
            }
            
            card.innerHTML = `
                <h3>${ins.titulo} <span style="font-size: 12px; color: #9ca3af; font-weight: 400;">#${ins.id_evento}</span></h3>
                <div class="evento-meta">
                    <span>🗓️ Data: ${ins.data_inicio}</span>
                    <span>📍 Local: ${ins.local}</span>
                    <span>👥 Papel: ${ins.tipo_participacao}</span>
                </div>
                <p style="color: #4b5563; margin-bottom: 10px; font-size: 14px;">${ins.descricao}</p>
                ${certificadoBtn}
            `;
            list.appendChild(card);
        });
    } catch(err) {
        list.innerHTML = `<p style="color: red; text-align: center; padding: 20px;">Erro: ${err.message}</p>`;
    }
}

window.abrirCertificado = function(eventoTitulo, carga, codigo, dataEmissao, papel) {
    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    document.getElementById('cert-aluno-nome').textContent = userData.name || 'Estudante UPE';
    document.getElementById('cert-evento-titulo').textContent = eventoTitulo;
    document.getElementById('cert-papel').textContent = papel || 'Ouvinte';
    document.getElementById('cert-carga').textContent = `${carga} horas`;
    document.getElementById('cert-codigo').textContent = codigo;
    
    const dataObj = new Date(dataEmissao);
    const dataFormatada = isNaN(dataObj.getTime()) ? new Date().toLocaleDateString('pt-BR') : dataObj.toLocaleDateString('pt-BR');
    document.getElementById('cert-data-emissao').textContent = dataFormatada;
    
    document.getElementById('modal-certificado').style.display = 'flex';
};
