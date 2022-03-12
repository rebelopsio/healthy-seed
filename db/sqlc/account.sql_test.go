package db

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_CreateAccount(t *testing.T) {
	arg := CreateAccountParams{
		FirstName:     "Jill",
		LastName:      "Bob",
		EmailAddress:  "jill.bob@test.fake",
		Gender:        "other",
		Age:           40,
		Height:        68,
		CurrentWeight: 150,
	}
	account, err := testQueries.CreateAccount(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, account)
	require.Equal(t, arg.FirstName, account.FirstName)
	require.Equal(t, arg.LastName, account.LastName)
	require.Equal(t, arg.EmailAddress, account.EmailAddress)
	require.Equal(t, arg.Gender, account.Gender)
	require.Equal(t, arg.Age, account.Age)
	require.Equal(t, arg.Height, account.Height)
	require.Equal(t, arg.CurrentWeight, account.CurrentWeight)
	require.NotZero(t, account.ID)
	require.NotZero(t, account.CreatedAt)
}
