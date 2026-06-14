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
