# UPE Connect Hub

<h1>
    <img src= "https://ik.imagekit.io/tntyaifd8/upe-connect-hub">
<h1>

<h3 align="center">
Conectando Talentos, Oportunidades e Desenvolvimento Acadêmico
</h3>

<p align="center">
  Plataforma acadêmica para networking, oportunidades e desenvolvimento profissional da Universidade de Pernambuco.
</p>

---

# UPE Connect Hub

## Plataforma Acadêmica de Oportunidades e Desenvolvimento Profissional

### Sobre o Projeto

O **UPE Connect Hub** é uma plataforma acadêmica desenvolvida como projeto da disciplina de Banco de Dados da Universidade de Pernambuco (UPE).

O sistema tem como objetivo centralizar a divulgação. O projeto consiste no desenvolvimento de um banco de dados relacional e uma interface simples para apoiar a gestão  de oportunidades acadêmicas e profissionais, permitindo que estudantes, professores, coordenação e empresas parceiras tenham acesso a um ambiente único para publicação e acompanhamento de vagas, eventos, bolsas, monitorias e projetos.

---

## Problema

Atualmente, as oportunidades acadêmicas da universidade são divulgadas de forma descentralizada através de:

* Grupos de WhatsApp;
* E-mails institucionais;
* Coordenação dos cursos;
* Murais físicos;
* Comunicação informal.

Essa situação dificulta o acesso às informações e pode resultar na perda de oportunidades importantes por parte dos estudantes.

---

## Solução Proposta

O UPE Connect Hub centraliza todas as oportunidades acadêmicas e profissionais em uma única plataforma, permitindo:

* Cadastro de usuários;
* Gerenciamento de competências;
* Publicação de vagas;
* Controle de candidaturas;
* Gerenciamento de eventos;
* Emissão de certificados;
* Sistema de notificações;
* Geração de relatórios institucionais.

---

## Objetivos

### Objetivo Geral

Desenvolver uma plataforma acadêmica que facilite o acesso a oportunidades e promova a integração entre universidade, estudantes e empresas parceiras.

### Objetivos Específicos

* Centralizar informações acadêmicas;
* Facilitar candidaturas;
* Organizar eventos institucionais;
* Gerar relatórios gerenciais;
* Melhorar o acompanhamento das oportunidades oferecidas pela universidade.

---

## Tecnologias Utilizadas

### Banco de Dados

* PostgreSQL

### Linguagem de Programação

* Python

### Bibliotecas

* psycopg2

### Modelagem

* BRModelo
* Draw.io

### Controle de Versão

* Git
* GitHub

---

## Estrutura do Projeto

```text
UPE-Connect-Hub/
│
├── docs/
├── sql/
├── app_teste/
├── diagramas/
├── seeders/
├── apresentacao/
└── README.md
```

---

## Estrutura do Banco de Dados

O banco foi projetado seguindo os princípios de normalização até a Terceira Forma Normal (3FN).

### Módulo Usuários

* usuarios
* perfis
* cursos
* departamentos
* tipos_usuario

### Módulo Competências

* habilidades
* usuario_habilidades
* certificacoes
* usuario_certificacoes
* areas_interesse
* usuario_areas_interesse

### Módulo Empresas

* empresas
* representantes_empresa

### Módulo Oportunidades

* tipos_vaga
* vagas
* requisitos_vaga
* vaga_habilidades

### Módulo Candidaturas

* candidaturas
* status_candidatura
* feedback_candidatura

### Módulo Eventos

* eventos
* participacoes
* certificados

### Módulo Controle

* notificacoes
* logs
* auditoria

Total aproximado: **26 tabelas**

---

## Funcionalidades

### Gestão de Usuários

* Cadastro de usuários
* Perfis acadêmicos
* Associação com cursos

### Gestão de Competências

* Habilidades
* Certificações
* Áreas de interesse

### Gestão de Empresas

* Empresas parceiras
* Representantes

### Gestão de Oportunidades

* Cadastro de vagas
* Requisitos
* Habilidades exigidas

### Gestão de Candidaturas

* Inscrição em vagas
* Acompanhamento de status
* Feedback

### Gestão de Eventos

* Cadastro de eventos
* Participações
* Certificados

### Sistema de Notificações

* Novas vagas
* Atualização de status
* Avisos institucionais

---

## Recursos Avançados

### Views

* vw_vagas_abertas
* vw_candidaturas_por_curso
* vw_eventos_populares
* vw_alunos_certificados
* vw_habilidades_requisitadas

### Procedures

* cadastrar_candidatura()
* publicar_vaga()
* gerar_relatorio_empregabilidade()

### Triggers

* Registro automático de logs
* Encerramento automático de vagas
* Geração automática de notificações

---

## Testes

O projeto possui uma aplicação simples em Python para validar o funcionamento do banco de dados, permitindo:

* Cadastro de usuários;
* Publicação de vagas;
* Realização de candidaturas;
* Consulta de relatórios;
* Teste das procedures e triggers.

---

## Integrantes

| Nome         | Responsabilidade              |
| ------------ | ----------------------------- |
| Integrante 1 | Requisitos e Documentação     |
| Integrante 2 | Modelagem e Diagramas         |
| Integrante 3 | Estrutura do Banco de Dados   |
| Integrante 4 | Procedures, Triggers e Testes |

---

## Disciplina

Banco de Dados

Universidade de Pernambuco – Campus Garanhuns

---

## Professor

Carlos Melo

---

## Licença

Projeto desenvolvido exclusivamente para fins acadêmicos.
