# UPA Monitor de Porto Velho — Modelagem de Dados e Business Intelligence

Repositório acadêmico/técnico contendo a modelagem de dados relacional e as consultas estatísticas (Stored Procedures) desenvolvidas para o sistema de monitoramento das Unidades de Pronto Atendimento (UPAs) de Porto Velho - RO.

## 🏛️ Sobre o Projeto
O **UPA Monitor** acompanha o fluxo de pacientes, filas, tempos de espera e indicadores de atendimento em tempo real. Este repositório traduz essa estrutura em um modelo relacional normalizado (3FN) utilizando **SQL Server** e **Mermaid**.

---

## 📊 Diagrama Entidade-Relacionamento (ER)

```mermaid
erDiagram
    UPA {
        int id_upa PK
        string nome_upa UK
        string endereco
        string status_operacional
    }
    SETOR {
        int id_setor PK
        int id_upa FK
        string nome_setor
        string descricao
    }
    CLASSIFICACAO_RISCO {
        int id_classificacao PK
        string cor_risco UK
        string descricao_fluxo
        int tempo_max_espera_minutos
    }
    PACIENTE {
        int id_paciente PK
        string cartao_sus UK
        string nome_completo
        date data_nascimento
        string sexo
    }
    ATENDIMENTO {
        int id_atendimento PK
        int id_upa FK
        int id_paciente FK
        int id_setor FK
        int id_classificacao FK
        datetime data_hora_chegada
        datetime data_hora_inicio_atendimento
        datetime data_hora_alta
        string status_atendimento
    }
    MEDICAO {
        int id_medicao PK
        int id_upa FK
        int id_setor FK
        datetime timestamp_medicao
        int qtd_pacientes_aguardando
        decimal tempo_medio_espera_minutos
        decimal tempo_medio_atendimento_minutos
    }

    UPA ||--o{ SETOR : "contém"
    UPA ||--o{ ATENDIMENTO : "realiza"
    UPA ||--o{ MEDICAO : "gera_metrica"
    SETOR ||--o{ ATENDIMENTO : "aloja_paciente"
    SETOR ||--o{ MEDICAO : "possui_metrica"
    CLASSIFICACAO_RISCO ||--o{ ATENDIMENTO : "classifica"
    PACIENTE ||--o{ ATENDIMENTO : "possui_historico"
