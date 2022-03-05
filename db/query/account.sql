-- name: CreateAccount :one
INSERT INTO accounts (
	first_name,
	last_name,
	email_address,
	gender,
	age,
	height,
	current_weight
) VALUES (
	$1, $2, $3, $4, $5, $6, $7
) RETURNING *;

-- name: GetAccount :one
SELECT * FROM accounts
WHERE id = $1 LIMIT 1;

-- name: ListAccounts :many
SELECT * FROM accounts
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateAccountWeight :exec
UPDATE accounts
SET current_weight = $2
WHERE id = $1;

-- name: UpdateAccountAge :exec
UPDATE accounts
SET age = $2
WHERE id = $1;

-- name: DeleteAccount :exec
DELETE FROM accounts
WHERE id = $1;
