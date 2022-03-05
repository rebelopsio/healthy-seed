-- name: CreateMacros :one
INSERT INTO macros
    (
    account_id,
    calories,
    protein,
    carbs,
    fats
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: ListMacros :one
SELECT * FROM macros
WHERE account_id = $1 LIMIT 1;

-- name: UpdateMacros :exec
UPDATE macros
SET protein = $2, fats = $3, carbs = $4, calories = $5
WHERE account_id = $1;

-- name: DeleteMacros :exec
DELETE FROM macros
WHERE account_id = $1;