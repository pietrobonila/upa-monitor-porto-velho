-- =====================================================================
-- Stored Procedures de Relatório e Monitoramento
-- =====================================================================

USE UpaMonitorDB;
GO

--------------------------------------------------------------------------------
-- Procedure: sp_quadro_de_filas
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_quadro_de_filas
    @id_upa INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        u.id_upa,
        u.nome_upa,
        s.nome_setor,
        c.cor_risco AS classificacao_risco,
        COUNT(a.id_atendimento) AS total_pacientes_aguardando,
        DATEDIFF(MINUTE, MIN(a.data_hora_chegada), GETDATE()) AS tempo_maximo_espera_atual_min
    FROM ATENDIMENTO a
    INNER JOIN UPA u ON a.id_upa = u.id_upa
    INNER JOIN SETOR s ON a.id_setor = s.id_setor
    INNER JOIN CLASSIFICACAO_RISCO c ON a.id_classificacao = c.id_classificacao
    WHERE a.status_atendimento = 'AGUARDANDO'
      AND (@id_upa IS NULL OR u.id_upa = @id_upa)
    GROUP BY 
        u.id_upa,
        u.nome_upa,
        s.nome_setor,
        c.cor_risco
    ORDER BY 
        u.nome_upa, 
        s.nome_setor, 
        c.cor_risco;
END;
GO

--------------------------------------------------------------------------------
-- Procedure: sp_atlas_e_cubos
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_atlas_e_cubos
    @data_inicio DATETIME = NULL,
    @data_fim DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @data_inicio = ISNULL(@data_inicio, CAST(GETDATE() AS DATE));
    SET @data_fim = ISNULL(@data_fim, GETDATE());

    SELECT 
        u.nome_upa,
        s.nome_setor,
        CAST(m.timestamp_medicao AS DATE) AS data_referencia,
        SUM(m.qtd_pacientes_aguardando) AS pico_pacientes_aguardando,
        CAST(AVG(CAST(m.tempo_medio_espera_minutos AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS media_geral_espera_min,
        CAST(AVG(CAST(m.tempo_medio_atendimento_minutos AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS media_geral_atendimento_min
    FROM MEDICAO m
    INNER JOIN UPA u ON m.id_upa = u.id_upa
    INNER JOIN SETOR s ON m.id_setor = s.id_setor
    WHERE m.timestamp_medicao BETWEEN @data_inicio AND @data_fim
    GROUP BY 
        u.nome_upa,
        s.nome_setor,
        CAST(m.timestamp_medicao AS DATE)
    ORDER BY 
        u.nome_upa, 
        s.nome_setor, 
        data_referencia DESC;
END;
GO
