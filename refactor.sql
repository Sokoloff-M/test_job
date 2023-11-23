WITH CTE AS
(
    SELECT
        ROW_NUMBER() OVER (PARTITION BY sa.DateEnd, sa.FlagActive ORDER BY (SELECT 100))) AS RN,
        cast(sa.DateEnd as date) as DateEnd,
        cd.ID as ID_dbo_CustomerDistributor,
        cast(isnull(sa.FlagActive, 0) as bit) as FlagActive
    FROM dbo.SalesAgreement sa
    INNER JOIN dbo.CustomerDistributor cd ON sa.ID_CustomerDistributor = cd.ID
    WHERE sa.FlagActive = 1 AND cd.FlagActive = 1
)
SELECT DateEnd, ID_dbo_CustomerDistributor, FlagActive
INTO #CustomerSeasonal
FROM CTE
WHERE RN = 1
-- рефакторинг кода