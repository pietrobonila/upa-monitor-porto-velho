# Diagrama Entidade-Relacionamento (ER) — UPA Monitor

Este documento apresenta o modelo conceitual e lógico em formato **Mermaid** desenvolvido para o sistema **UPA Monitor de Porto Velho**.

## Código do Diagrama

```mermaid
erDiagram
    %% Comentário: A entidade UPA representa cada unidade de saúde física monitorada.
    UPA {
        int id_upa PK
        string nome_upa UK
        string endereco
        string status_operacional
    }

    %% Comentário: SETOR categoriza os ambientes de atendimento dentro de cada UPA.
    SETOR {
        int id_setor PK
        int id_upa FK
        string nome_setor
        string descricao
    }

    %% Comentário: CLASSIFICACAO_RISCO define a prioridade clínica (Protocolo de Manchester).
    CLASSIFICACAO_RISCO {
        int id_classificacao PK
        string cor_risco UK
        string descricao_fluxo
        int tempo_max_espera_minutos
    }

    %% Comentário: PACIENTE armazena o cadastro básico dos cidadãos.
    PACIENTE {
        int id_paciente PK
        string cartao_sus UK
        string nome_completo
        date data_nascimento
        string sexo
    }

    %% Comentário: ATENDIMENTO registra a passagem do paciente pela unidade.
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

    %% Comentário: MEDICAO armazena snapshots para popular os dashboards em tempo real.
    MEDICAO {
        int id_medicao PK
        int id_upa FK
        int id_setor FK
        datetime timestamp_medicao
        int qtd_pacientes_aguardando
        decimal tempo_medio_espera_minutos
        decimal tempo_medio_atendimento_minutos
    }

    %% Relacionamentos com Notação Crow's Foot
    UPA ||--o{ SETOR : "contém"
    UPA ||--o{ ATENDIMENTO : "realiza"
    UPA ||--o{ MEDICAO : "gera_metrica"
    SETOR ||--o{ ATENDIMENTO : "aloja_paciente"
    SETOR ||--o{ MEDICAO : "possui_metrica"
    CLASSIFICACAO_RISCO ||--o{ ATENDIMENTO : "classifica"
    PACIENTE ||--o{ ATENDIMENTO : "possui_historico"
