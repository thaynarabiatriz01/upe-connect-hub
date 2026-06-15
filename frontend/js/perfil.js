const API_URL = 'http://localhost:8000';

document.addEventListener('DOMContentLoaded', async () => {
    const token = localStorage.getItem('upe_token');
    if (!token) {
        window.location.href = 'index.html';
        return;
    }

    const userData = JSON.parse(localStorage.getItem('upe_user') || '{}');
    document.getElementById('user-name').textContent = `${userData.name} (${userData.role})`;

    // Lógica do botão Voltar (redireciona com base no cargo)
    document.getElementById('btn-voltar').addEventListener('click', () => {
        if (userData.role === 'Administrador') window.location.href = 'admin.html';
        else if (userData.role === 'Professor') window.location.href = 'professor.html';
        else if (userData.role === 'Pesquisador') window.location.href = 'pesquisador.html';
        else window.location.href = 'dashboard.html';
    });

    document.getElementById('logout-btn').addEventListener('click', () => {
        localStorage.clear();
        window.location.href = 'index.html';
    });

    // 1. Carrega os dados existentes (se houver)
    await carregarPerfil(token);

    // 2. Lógica de Salvar (Upsert)
    document.getElementById('form-perfil').addEventListener('submit', async (e) => {
        e.preventDefault();
        const btn = e.submitter;
        btn.textContent = "Salvando...";
        btn.disabled = true;

        const payload = {
            id_curso: parseInt(document.getElementById('p_curso').value),
            periodo: parseInt(document.getElementById('p_periodo').value),
            foto_perfil: document.getElementById('p_foto').value || null,
            linkedin: document.getElementById('p_linkedin').value || null,
            github: document.getElementById('p_github').value || null,
            biografia: document.getElementById('p_biografia').value || null
        };

        try {
            const response = await fetch(`${API_URL}/usuarios/perfil`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`
                },
                body: JSON.stringify(payload)
            });

            if (!response.ok) throw new Error("Erro ao salvar perfil.");

            alert("✅ Perfil salvo com sucesso!");
        } catch (error) {
            alert("Erro: " + error.message);
        } finally {
            btn.textContent = "Salvar Perfil";
            btn.disabled = false;
        }
    })    // 3. Carrega os catálogos para preencher os selects
    await carregarCatalogos();
    
    // 4. Carrega as listas de habilidades, certificações e áreas do usuário
    await carregarMinhasHabilidades(token);
    await carregarMinhasCertificacoes(token);
    await carregarMinhasAreasInteresse(token);

    // 5. Lógica para adicionar habilidade
    document.getElementById('form-habilidade').addEventListener('submit', async (e) => {
        e.preventDefault();
        const payload = {
            id_habilidade: parseInt(document.getElementById('hab_select').value),
            nivel: document.getElementById('hab_nivel').value
        };
        try {
            const response = await fetch(`${API_URL}/usuarios/habilidades`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
                body: JSON.stringify(payload)
            });
            if (!response.ok) {
                const err = await response.json();
                throw new Error(err.detail || "Erro");
            }
            alert("✅ Habilidade adicionada!");
            document.getElementById('form-habilidade').reset();
            carregarMinhasHabilidades(token);
        } catch (err) {
            alert("Erro: " + err.message);
        }
    });

    // 6. Lógica para adicionar certificação
    document.getElementById('form-certificacao').addEventListener('submit', async (e) => {
        e.preventDefault();
        const payload = {
            id_certificacao: parseInt(document.getElementById('cert_select').value),
            data_conclusao: document.getElementById('cert_data').value
        };
        try {
            const response = await fetch(`${API_URL}/usuarios/certificacoes`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
                body: JSON.stringify(payload)
            });
            if (!response.ok) {
                const err = await response.json();
                throw new Error(err.detail || "Erro");
            }
            alert("✅ Certificação adicionada!");
            document.getElementById('form-certificacao').reset();
            carregarMinhasCertificacoes(token);
        } catch (err) {
            alert("Erro: " + err.message);
        }
    });

    // 7. Lógica para adicionar área de interesse
    document.getElementById('form-area').addEventListener('submit', async (e) => {
        e.preventDefault();
        const payload = {
            id_area: parseInt(document.getElementById('area_select').value)
        };
        try {
            const response = await fetch(`${API_URL}/usuarios/areas_interesse`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
                body: JSON.stringify(payload)
            });
            if (!response.ok) {
                const err = await response.json();
                throw new Error(err.detail || "Erro");
            }
            alert("✅ Área de interesse adicionada!");
            document.getElementById('form-area').reset();
            carregarMinhasAreasInteresse(token);
        } catch (err) {
            alert("Erro: " + err.message);
        }
    });

});

async function carregarPerfil(token) {
    try {
        const response = await fetch(`${API_URL}/usuarios/perfil`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });

        if (response.ok) {
            const perfil = await response.json();
            document.getElementById('p_curso').value = perfil.id_curso || '';
            document.getElementById('p_periodo').value = perfil.periodo || '';
            document.getElementById('p_foto').value = perfil.foto_perfil || '';
            document.getElementById('p_linkedin').value = perfil.linkedin || '';
            document.getElementById('p_github').value = perfil.github || '';
            document.getElementById('p_biografia').value = perfil.biografia || '';
        }
    } catch (err) {
        console.log("Perfil ainda não cadastrado ou erro ao buscar.");
    }
}

async function carregarCatalogos() {
    try {
        const [habRes, certRes, areaRes] = await Promise.all([
            fetch(`${API_URL}/usuarios/todas_habilidades`),
            fetch(`${API_URL}/usuarios/todas_certificacoes`),
            fetch(`${API_URL}/usuarios/todas_areas_interesse`)
        ]);
        
        if (habRes.ok) {
            const habilidades = await habRes.json();
            const habSelect = document.getElementById('hab_select');
            habilidades.forEach(h => {
                const opt = document.createElement('option');
                opt.value = h.id_habilidade;
                opt.textContent = h.nome;
                habSelect.appendChild(opt);
            });
        }
        
        if (certRes.ok) {
            const certificacoes = await certRes.json();
            const certSelect = document.getElementById('cert_select');
            certificacoes.forEach(c => {
                const opt = document.createElement('option');
                opt.value = c.id_certificacao;
                opt.textContent = `${c.nome} (${c.instituicao})`;
                certSelect.appendChild(opt);
            });
        }

        if (areaRes.ok) {
            const areas = await areaRes.json();
            const areaSelect = document.getElementById('area_select');
            areas.forEach(a => {
                const opt = document.createElement('option');
                opt.value = a.id_area;
                opt.textContent = a.nome;
                areaSelect.appendChild(opt);
            });
        }
    } catch(err) {
        console.error("Erro ao carregar catálogos", err);
    }
}

async function carregarMinhasHabilidades(token) {
    try {
        const response = await fetch(`${API_URL}/usuarios/habilidades`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const tbody = document.getElementById('habilidades-tbody');
        tbody.innerHTML = '';
        
        if (response.ok) {
            const habilidades = await response.json();
            if (habilidades.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3" style="text-align: center; color: #6b7280;">Nenhuma habilidade cadastrada.</td></tr>';
                return;
            }
            habilidades.forEach(h => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td style="padding: 10px; border-bottom: 1px solid #f3f4f6;">${h.nome}</td>
                    <td style="padding: 10px; border-bottom: 1px solid #f3f4f6;">${h.nivel}</td>
                    <td style="padding: 10px; text-align: center; border-bottom: 1px solid #f3f4f6;">
                        <button class="btn-primary" style="background: #ef4444; padding: 4px 8px; font-size: 12px; width: auto;" onclick="removerHabilidade(${h.id_habilidade})">Excluir</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        }
    } catch(err) {
        console.error(err);
    }
}

window.removerHabilidade = async function(id) {
    if(!confirm("Remover esta habilidade do seu currículo?")) return;
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/usuarios/habilidades/${id}`, {
            method: 'DELETE',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if(response.ok) {
            carregarMinhasHabilidades(token);
        } else {
            const err = await response.json();
            alert("Erro ao remover: " + err.detail);
        }
    } catch(err) {
        alert("Erro ao remover");
    }
};

async function carregarMinhasCertificacoes(token) {
    try {
        const response = await fetch(`${API_URL}/usuarios/certificacoes`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const tbody = document.getElementById('certificacoes-tbody');
        tbody.innerHTML = '';
        
        if (response.ok) {
            const certs = await response.json();
            if (certs.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3" style="text-align: center; color: #6b7280;">Nenhuma certificação cadastrada.</td></tr>';
                return;
            }
            certs.forEach(c => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td style="padding: 10px; border-bottom: 1px solid #f3f4f6;"><strong>${c.nome}</strong><br><span style="font-size:12px;color:#6b7280;">${c.instituicao}</span></td>
                    <td style="padding: 10px; border-bottom: 1px solid #f3f4f6;">${c.data_conclusao}</td>
                    <td style="padding: 10px; text-align: center; border-bottom: 1px solid #f3f4f6;">
                        <button class="btn-primary" style="background: #ef4444; padding: 4px 8px; font-size: 12px; width: auto;" onclick="removerCertificacao(${c.id_certificacao})">Excluir</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        }
    } catch(err) {
        console.error(err);
    }
}

window.removerCertificacao = async function(id) {
    if(!confirm("Remover esta certificação?")) return;
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/usuarios/certificacoes/${id}`, {
            method: 'DELETE',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if(response.ok) {
            carregarMinhasCertificacoes(token);
        } else {
            const err = await response.json();
            alert("Erro ao remover: " + err.detail);
        }
    } catch(err) {
        alert("Erro ao remover");
    }
};

async function carregarMinhasAreasInteresse(token) {
    try {
        const response = await fetch(`${API_URL}/usuarios/areas_interesse`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const tbody = document.getElementById('areas-tbody');
        tbody.innerHTML = '';
        
        if (response.ok) {
            const areas = await response.json();
            if (areas.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3" style="text-align: center; color: #6b7280;">Nenhuma área de interesse cadastrada.</td></tr>';
                return;
            }
            areas.forEach(a => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td style="padding: 10px; border-bottom: 1px solid #f3f4f6;"><strong>${a.nome}</strong></td>
                    <td style="padding: 10px; border-bottom: 1px solid #f3f4f6; color: #6b7280; font-size:13px;">${a.descricao || 'Sem descrição.'}</td>
                    <td style="padding: 10px; text-align: center; border-bottom: 1px solid #f3f4f6;">
                        <button class="btn-primary" style="background: #ef4444; padding: 4px 8px; font-size: 12px; width: auto;" onclick="removerAreaInteresse(${a.id_area})">Excluir</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        }
    } catch(err) {
        console.error(err);
    }
}

window.removerAreaInteresse = async function(id) {
    if(!confirm("Remover esta área de interesse?")) return;
    const token = localStorage.getItem('upe_token');
    try {
        const response = await fetch(`${API_URL}/usuarios/areas_interesse/${id}`, {
            method: 'DELETE',
            headers: { 'Authorization': `Bearer ${token}` }
        });
        if(response.ok) {
            carregarMinhasAreasInteresse(token);
        } else {
            const err = await response.json();
            alert("Erro ao remover: " + err.detail);
        }
    } catch(err) {
        alert("Erro ao remover");
    }
};
