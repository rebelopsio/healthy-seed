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
