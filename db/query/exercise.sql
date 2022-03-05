-- name: CreateExercise :one
INSERT INTO exercise (
    account_id,
    type,
    calories_burned,
    start_time,
    stop_time
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetExercise :one
SELECT * FROM exercise
WHERE id = $1 LIMIT 1;

-- name: ListExercise :many
SELECT * FROM exercise
WHERE account_id = $1
ORDER BY id
LIMIT $2
OFFSET $3;

-- name: UpdateExercise :exec
UPDATE exercise
SET start_time = $2, stop_time = $3, type = $4, calories_burned = $5
WHERE id = $1;

-- name: DeleteExercise :exec
DELETE FROM exercise
WHERE id = $1;
