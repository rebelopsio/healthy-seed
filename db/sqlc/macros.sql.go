// Code generated by sqlc. DO NOT EDIT.
// source: macros.sql

package db

import (
	"context"
	"database/sql"
)

const createMacros = `-- name: CreateMacros :one
INSERT INTO macros
    (
    account_id,
    calories,
    protein,
    carbs,
    fats
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING id, account_id, protein, fats, carbs, calories, created_at
`

type CreateMacrosParams struct {
	AccountID sql.NullInt64 `json:"account_id"`
	Calories  int32         `json:"calories"`
	Protein   int32         `json:"protein"`
	Carbs     int32         `json:"carbs"`
	Fats      int32         `json:"fats"`
}

func (q *Queries) CreateMacros(ctx context.Context, arg CreateMacrosParams) (Macro, error) {
	row := q.db.QueryRowContext(ctx, createMacros,
		arg.AccountID,
		arg.Calories,
		arg.Protein,
		arg.Carbs,
		arg.Fats,
	)
	var i Macro
	err := row.Scan(
		&i.ID,
		&i.AccountID,
		&i.Protein,
		&i.Fats,
		&i.Carbs,
		&i.Calories,
		&i.CreatedAt,
	)
	return i, err
}

const deleteMacros = `-- name: DeleteMacros :exec
DELETE FROM macros
WHERE account_id = $1
`

func (q *Queries) DeleteMacros(ctx context.Context, accountID sql.NullInt64) error {
	_, err := q.db.ExecContext(ctx, deleteMacros, accountID)
	return err
}

const listMacros = `-- name: ListMacros :one
SELECT id, account_id, protein, fats, carbs, calories, created_at FROM macros
WHERE account_id = $1 LIMIT 1
`

func (q *Queries) ListMacros(ctx context.Context, accountID sql.NullInt64) (Macro, error) {
	row := q.db.QueryRowContext(ctx, listMacros, accountID)
	var i Macro
	err := row.Scan(
		&i.ID,
		&i.AccountID,
		&i.Protein,
		&i.Fats,
		&i.Carbs,
		&i.Calories,
		&i.CreatedAt,
	)
	return i, err
}

const updateMacros = `-- name: UpdateMacros :exec
UPDATE macros
SET protein = $2, fats = $3, carbs = $4, calories = $5
WHERE account_id = $1
`

type UpdateMacrosParams struct {
	AccountID sql.NullInt64 `json:"account_id"`
	Protein   int32         `json:"protein"`
	Fats      int32         `json:"fats"`
	Carbs     int32         `json:"carbs"`
	Calories  int32         `json:"calories"`
}

func (q *Queries) UpdateMacros(ctx context.Context, arg UpdateMacrosParams) error {
	_, err := q.db.ExecContext(ctx, updateMacros,
		arg.AccountID,
		arg.Protein,
		arg.Fats,
		arg.Carbs,
		arg.Calories,
	)
	return err
}
