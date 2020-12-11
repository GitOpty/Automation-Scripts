SELECT O.NR_SEQ_WHEB OS
    --, CONVERT(VARCHAR(10), HEXT.DT_ATUALIZACAO, 103) ATUALIZACAO
    --, SUBSTRING(dbo.fn_CONVERTRTF2TEXT(UPPER(HEXT.DS_RELAT_TECNICO)),1,90) + ' ...' RETORNO
    , UPPER(O.NM_SOLICITANTE) SOLICITANTE
    , CONVERT(VARCHAR(10), O.DT_ORDEM_SERVICO, 103) ABERTURA
    , UPPER(O.DS_DANO_BREVE) DESCRICAO
	, UPPER(SUBSTRING(O.DS_DANO, 1, 90)) + '...' DANO
FROM ORDEM_SERVICO_TERCEIROS O
    --INNER JOIN ORDEM_SERVICO_TERC_HIST HEXT
        --ON O.NR_SEQUENCIA = HEXT.NR_SEQ_ORDEM_SERV AND HEXT.NR_SEQUENCIA_HIST = (SELECT MAX(HINT.NR_SEQUENCIA_HIST) FROM ORDEM_SERVICO_TERC_HIST HINT WHERE HINT.NR_SEQ_ORDEM_SERV = O.NR_SEQUENCIA)
WHERE UPPER(O.DS_DANO) LIKE '%APURA%'
O.IE_STATUS_ORDEM <> 'Encerrada'
    AND O.DS_LOCALIZACAO = 'Tasy'
	AND 
    AND O.DS_ESTAGIO = 'Retorno Philips'
ORDER BY HEXT.DT_ATUALIZACAO ASC

CREATE FUNCTION dbo.fn_CONVERTRTF2TEXT
(@In VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	If isnull(@In,'') = '' return ''
	If @In not like '{\rtf%' return @In
	Declare @Len int
	Declare @Loc int = 1
	Declare @Char char(1) = ''
	Declare @PrevChar char(1) = ''
	Declare @NextChar char(1) = ''
	Declare @InMarkup int = 0
	Declare @InBrackets int = -1
	Declare @Out varchar(max) = ''

		Set @Len = len(@In)
		While @Loc < @Len begin
			Set @PrevChar = @Char
			Set @Char = SUBSTRING(@In, @Loc, 1)
			If @Loc < @Len set @NextChar = SUBSTRING(@In, @Loc + 1, 1) else set @NextChar = ''
			Set @Loc = @Loc + 1
			If @Char = '{' and @PrevChar != '\' begin
				Set @InBrackets = @InBrackets + 1
				Continue
			End
			If @Char = '}' and @PrevChar != '\' begin
				Set @InBrackets = @InBrackets - 1
				Continue
			End
			If @Char = '\' and @PrevChar != '\' and @NextChar not in ('\','{','}','~','-','_') begin
				Set @InMarkup = 1
				continue
			End
			If @Char = ' ' or @Char = char(13) begin
				Set @InMarkup = 0
			
			End
			If @InMarkup > 0 or @InBrackets > 0 continue
		
			Set @Out = @Out + @Char

		End

	Set @Out = replace(@Out, '\\', '\')
	Set @Out = replace(@Out, '\{', '{')
	Set @Out = replace(@Out, '\}', '}')
	Set @Out = replace(@Out, '\~', ' ')
	Set @Out = replace(@Out, '\-', '-')
	Set @Out = replace(@Out, '\_', '-')

	WHILE ASCII(@Out) < 33
	BEGIN
	set @Out = substring(@Out,2,len(@Out))
	END

	set @Out = reverse(@Out)

	WHILE ASCII(@Out) < 33
	BEGIN
	set @Out = substring(@Out,2,len(@Out))
	END

	set @Out = reverse(@Out)

	RETURN LTRIM(RTRIM(@Out))
End

SELECT *
FROM ORDEM_SERVICO_TERC_HIST H
WHERE H.NR_SEQ_ORDEM_SERV = 5848
ORDER BY H.NR_SEQUENCIA_HIST DESC;

SELECT GETDATE(), GETDATE()-7

SELECT ROW_NUMBER() OVER (ORDER BY HEXT.DT_ATUALIZACAO ASC) ITEM
	, O.NR_SEQ_WHEB OS
	, O.IE_STATUS_ORDEM
	, O.DS_LOCALIZACAO
	, O.DS_ESTAGIO
    , CONVERT(VARCHAR(10), HEXT.DT_ATUALIZACAO, 103) ATUALIZACAO
    , SUBSTRING(dbo.fn_CONVERTRTF2TEXT(UPPER(HEXT.DS_RELAT_TECNICO)),1,90) + ' ...' RETORNO
    , UPPER(O.NM_SOLICITANTE) SOLICITANTE
    , CONVERT(VARCHAR(10), O.DT_ORDEM_SERVICO, 103) ABERTURA
    , UPPER(O.DS_DANO_BREVE) DESCRICAO
	, UPPER(SUBSTRING(O.DS_DANO, 1, 90)) + '...' DANO
FROM ORDEM_SERVICO_TERCEIROS O
    INNER JOIN ORDEM_SERVICO_TERC_HIST HEXT
        ON O.NR_SEQUENCIA = HEXT.NR_SEQ_ORDEM_SERV AND HEXT.NR_SEQUENCIA_HIST = (SELECT MAX(HINT.NR_SEQUENCIA_HIST) FROM ORDEM_SERVICO_TERC_HIST HINT WHERE HINT.NR_SEQ_ORDEM_SERV = O.NR_SEQUENCIA)
WHERE O.IE_STATUS_ORDEM <> 'Encerrada'
    AND O.DS_LOCALIZACAO = 'Tasy'
    AND O.DS_ESTAGIO = 'Retorno Philips'
ORDER BY HEXT.DT_ATUALIZACAO ASC

/* PROCEDURES */
DROP PROCEDURE dbo.sp_TRUNCATEOSPHILIPS
GO
CREATE PROCEDURE dbo.sp_TRUNCATEOSPHILIPS
AS
    TRUNCATE TABLE dbo.ORDEM_SERVICO_TERCEIROS;
    TRUNCATE TABLE dbo.ORDEM_SERVICO_TERC_HIST;
GO
