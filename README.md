# UPE Connect Hub

<p align="center">
  <img src="./assets/logo/logo.png" width="180"/>
</p>

<h3 align="center">
Conectando Talentos, Oportunidades e Desenvolvimento Acadêmico
</h3>

<p align="center">
  Plataforma acadêmica para networking, oportunidades e desenvolvimento profissional da Universidade de Pernambuco.
</p>

---

# Sobre o Projeto

O **UPE Connect Hub** é uma plataforma acadêmica desenvolvida para centralizar oportunidades, networking e desenvolvimento profissional dentro da Universidade de Pernambuco – Campus Garanhuns.

A proposta do sistema é integrar estudantes, professores, coordenação e empresas parceiras em um único ambiente digital, facilitando a divulgação e o acesso a:

- oportunidades acadêmicas
- estágios
- monitorias
- bolsas
- projetos de pesquisa
- eventos
- networking acadêmico

O projeto busca resolver problemas de descentralização das informações acadêmicas e profissionais dentro da universidade.

---

# Objetivos

## Objetivo Geral

Desenvolver uma plataforma acadêmica relacional capaz de conectar membros da universidade e ampliar o acesso a oportunidades acadêmicas e profissionais.

## Objetivos Específicos

- Centralizar divulgação de oportunidades
- Facilitar candidaturas
- Promover networking acadêmico
- Organizar eventos e projetos
- Gerar relatórios institucionais
- Auxiliar no acompanhamento de empregabilidade

---

# Funcionalidades

## Perfil Acadêmico

- Cadastro de perfil acadêmico
- Habilidades técnicas
- Certificações
- Projetos desenvolvidos
- Portfólio
- Currículo

## Mural de Oportunidades

- Estágios
- Monitorias
- Bolsas
- Projetos de extensão
- Projetos de pesquisa
- Eventos acadêmicos

## Sistema de Candidaturas

- Envio de candidaturas
- Acompanhamento de status
- Feedback
- Notificações

## Networking Acadêmico

- Conexões entre usuários
- Comunidades
- Grupos acadêmicos
- Mensagens

## Eventos Acadêmicos

- Inscrições
- Participações
- Certificados
- Histórico de eventos

## Dashboard Institucional

- Métricas acadêmicas
- Relatórios
- Indicadores institucionais

---

# Tecnologias Utilizadas

## Banco de Dados
- MySQL

## Backend
- Python
- Flask

## Frontend
- HTML
- CSS
- JavaScript
- Bootstrap

## Ferramentas
- Git
- GitHub
- MySQL Workbench
- Draw.io
- Postman

---

# Estrutura do Projeto

```bash
upe-connect-hub/
│
├── docs/
├── database/
├── backend/
├── frontend/
├── tests/
├── assets/
│
├── README.md
├── LICENSE
├── .gitignore
└── requirements.txt
```

---

# Estrutura do Banco de Dados

O sistema será dividido em módulos:

## Módulo 1 — Usuários
- usuarios
- perfis
- cursos
- departamentos
- tipos_usuario

## Módulo 2 — Competências
- habilidades
- usuario_habilidades
- certificacoes
- usuario_certificacoes

## Módulo 3 — Oportunidades
- vagas
- tipos_vaga
- empresas
- candidaturas
- status_candidatura

## Módulo 4 — Social
- conexoes
- mensagens
- grupos
- membros_grupo
- postagens
- comentarios

## Módulo 5 — Acadêmico
- projetos
- eventos
- participacoes
- orientadores

## Módulo 6 — Controle
- notificacoes
- logs
- auditoria
- recomendacoes

---

# Recursos Avançados

## Triggers

- Atualização automática de status de vagas
- Registro de logs de candidaturas
- Notificações automáticas

## Procedures

- cadastrar_candidatura()
- recomendar_vagas()
- gerar_relatorio_empregabilidade()

## Views

- vw_alunos_ativos
- vw_vagas_abertas
- vw_candidaturas_por_curso
- vw_eventos_populares

---

# Status do Projeto

🚧 Projeto em desenvolvimento.

Atualmente nas fases de:
- levantamento de requisitos
- modelagem de banco de dados
- documentação
- arquitetura do sistema

---

# Roadmap

## Fase 1
- Modelagem do banco
- DER e MER
- Normalização

## Fase 2
- Criação das tabelas
- Procedures
- Triggers
- Views

## Fase 3
- Desenvolvimento da API

## Fase 4
- Desenvolvimento da interface

## Fase 5
- Dashboard institucional
- Match inteligente

---

# Integrantes

- Nome do Integrante — Função
- Nome do Integrante — Função
- Nome do Integrante — Função
- Nome do Integrante — Função

---

# Documentação

A documentação do projeto estará disponível na pasta:

```bash
/docs
```

---

# Como Executar o Projeto

## Clone o repositório

```bash
git clone https://github.com/seu-usuario/upe-connect-hub.git
```

## Acesse a pasta

```bash
cd upe-connect-hub
```

## Instale as dependências

```bash
pip install -r requirements.txt
```

---

# Diferenciais do Projeto

✔ Rede social acadêmica institucional  
✔ Centralização de oportunidades  
✔ Sistema de recomendação inteligente  
✔ Dashboard institucional  
✔ Plataforma integrada para desenvolvimento acadêmico e profissional  

---

# Contribuição

Este projeto está sendo desenvolvido para fins acadêmicos pela equipe responsável pelo UPE Connect Hub.

---

# Licença

Este projeto está sob a licença MIT.

---

# Universidade de Pernambuco

Projeto acadêmico desenvolvido para a Universidade de Pernambuco — Campus Garanhuns.
