package main

import (
	"errors"
	"fmt"
	"os"
	"time"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"arpitmalik832/go-template/src/greeting"
)

func init() {
	// Pretty print logs for development
	log.Logger = log.Output(zerolog.ConsoleWriter{
		Out:        os.Stdout,
		TimeFormat: time.RFC3339,
		NoColor:    false,
	})

	// Set global log level
	zerolog.SetGlobalLevel(zerolog.DebugLevel)

	// Add file and line number to log
	log.Logger = log.With().Caller().Logger()
}

func main() {
	// Example log messages
	log.Info().
		Str("server", "webhook").
		Int("port", 3000).
		Msg("Server is starting")

	// Replace your existing log.Printf with structured logging
	log.Debug().
		Str("event", "webhook").
		Msg("Received webhook request")

	log.Error().
		Err(errors.New("sample error")).
		Str("event", "webhook").
		Msg("Failed to process webhook")

	fmt.Println(greeting.Welcome())

	fmt.Printf("good to see you here.")
}
