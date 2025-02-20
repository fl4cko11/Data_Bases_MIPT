SELECT 
    ID,
    ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) AS BMI,
    CASE
        WHEN ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) < 18.5 THEN 'underweight'
        WHEN ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) >= 18.5
             AND ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) < 25 THEN 'normal'
        WHEN ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) >= 25
             AND ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) < 30 THEN 'overweight'
        WHEN ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) >= 30
             AND ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) < 35 THEN 'obese'
        WHEN ((WEIGHT * 0.453597) / ((HEIGHT * 0.0254) * (HEIGHT * 0.0254))) >= 35 THEN 'extremely obese'
    END AS type
FROM
    HW_1.HW
ORDER BY
    BMI DESC, ID DESC;
