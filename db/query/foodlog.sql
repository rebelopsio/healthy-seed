-- name: CreateFoodlog :one
INSERT INTO foodlog (
    account_id,
    calories,
    protein,
    carbs,
    fat
) VALUES (
     $1, $2, $3, $4, $5
 ) RETURNING *;

-- name: GetFoodlog :one
SELECT * FROM foodlog
WHERE id = $1;

-- name: ListFoodlogs :many
SELECT * FROM foodlog
WHERE account_id = $1
ORDER BY created_at DESC
LIMIT $2
OFFSET $3;

-- name: UpdateFoodlog :exec
UPDATE foodlog
SET protein = $2, fat = $3, carbs = $4
WHERE id = $1;

-- name: DeleteFoodlog :exec
DELETE FROM foodlog
WHERE id = $1;

