package greeting

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// basic test
func TestGreeting(t *testing.T) {
	assert.Equal(t, "hey, there", Welcome(), "They should be equal")
}
