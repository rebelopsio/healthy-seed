// Code generated by sqlc. DO NOT EDIT.
// source: account.sql

package db

import (
	"context"
	"database/sql"
)

const createAccount = `-- name: CreateAccount :one
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
) RETURNING id, first_name, last_name, email_address, gender, age, height, current_weight, created_at
`

type CreateAccountParams struct {
	FirstName     sql.NullString `json:"first_name"`
	LastName      string         `json:"last_name"`
	EmailAddress  string         `json:"email_address"`
	Gender        string         `json:"gender"`
	Age           int32          `json:"age"`
	Height        int32          `json:"height"`
	CurrentWeight int32          `json:"current_weight"`
}

func (q *Queries) CreateAccount(ctx context.Context, arg CreateAccountParams) (Account, error) {
	row := q.db.QueryRowContext(ctx, createAccount,
		arg.FirstName,
		arg.LastName,
		arg.EmailAddress,
		arg.Gender,
		arg.Age,
		arg.Height,
		arg.CurrentWeight,
	)
	var i Account
	err := row.Scan(
		&i.ID,
		&i.FirstName,
		&i.LastName,
		&i.EmailAddress,
		&i.Gender,
		&i.Age,
		&i.Height,
		&i.CurrentWeight,
		&i.CreatedAt,
	)
	return i, err
}

const deleteAccount = `-- name: DeleteAccount :exec
DELETE FROM accounts
WHERE id = $1
`

func (q *Queries) DeleteAccount(ctx context.Context, id int64) error {
	_, err := q.db.ExecContext(ctx, deleteAccount, id)
	return err
}

const getAccount = `-- name: GetAccount :one
SELECT id, first_name, last_name, email_address, gender, age, height, current_weight, created_at FROM accounts
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetAccount(ctx context.Context, id int64) (Account, error) {
	row := q.db.QueryRowContext(ctx, getAccount, id)
	var i Account
	err := row.Scan(
		&i.ID,
		&i.FirstName,
		&i.LastName,
		&i.EmailAddress,
		&i.Gender,
		&i.Age,
		&i.Height,
		&i.CurrentWeight,
		&i.CreatedAt,
	)
	return i, err
}

const listAccounts = `-- name: ListAccounts :many
SELECT id, first_name, last_name, email_address, gender, age, height, current_weight, created_at FROM accounts
ORDER BY id
LIMIT $1
OFFSET $2
`

type ListAccountsParams struct {
	Limit  int32 `json:"limit"`
	Offset int32 `json:"offset"`
}

func (q *Queries) ListAccounts(ctx context.Context, arg ListAccountsParams) ([]Account, error) {
	rows, err := q.db.QueryContext(ctx, listAccounts, arg.Limit, arg.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Account
	for rows.Next() {
		var i Account
		if err := rows.Scan(
			&i.ID,
			&i.FirstName,
			&i.LastName,
			&i.EmailAddress,
			&i.Gender,
			&i.Age,
			&i.Height,
			&i.CurrentWeight,
			&i.CreatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const updateAccountAge = `-- name: UpdateAccountAge :exec
UPDATE accounts
SET age = $2
WHERE id = $1
`

type UpdateAccountAgeParams struct {
	ID  int64 `json:"id"`
	Age int32 `json:"age"`
}

func (q *Queries) UpdateAccountAge(ctx context.Context, arg UpdateAccountAgeParams) error {
	_, err := q.db.ExecContext(ctx, updateAccountAge, arg.ID, arg.Age)
	return err
}

const updateAccountWeight = `-- name: UpdateAccountWeight :exec
UPDATE accounts
SET current_weight = $2
WHERE id = $1
`

type UpdateAccountWeightParams struct {
	ID            int64 `json:"id"`
	CurrentWeight int32 `json:"current_weight"`
}

func (q *Queries) UpdateAccountWeight(ctx context.Context, arg UpdateAccountWeightParams) error {
	_, err := q.db.ExecContext(ctx, updateAccountWeight, arg.ID, arg.CurrentWeight)
	return err
}
