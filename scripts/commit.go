package main

import (
	"flag"
	"log"
	"time"

	"github.com/PaloAltoNetworks/pango"
	"github.com/PaloAltoNetworks/pango/commit"
)

func main() {
	// Setup and parse command-line flags
	var (
		hostname    string
		apiKey      string
		deviceGroup string
		commitFlag        = true
		pushFlag          = true
		force             = true
		sleepTime   int64 = 1
		timeout     int   = 10
	)

	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)

	flag.StringVar(&hostname, "host", hostname, "PAN-OS hostname")
	flag.StringVar(&apiKey, "key", apiKey, "PAN-OS API key")
	flag.BoolVar(&commitFlag, "commit", commitFlag, "Commit configuration")
	flag.BoolVar(&pushFlag, "push", pushFlag, "Push configuration")
	flag.StringVar(&deviceGroup, "devicegroup", deviceGroup, "Device group")
	flag.Int64Var(&sleepTime, "sleep", sleepTime, "Seconds to sleep between checks for commit completion")
	flag.IntVar(&timeout, "timeout", timeout, "The timeout for all PAN-OS API calls")
	flag.BoolVar(&force, "force", force, "Force a commit even if one isn't needed")

	flag.Parse()

	// Initialize PAN-OS Panorama connection
	pano, err := initializePanorama(hostname, apiKey, timeout)
	if err != nil {
		log.Fatalf("Failed to initialize Panorama: %s", err)
	}

	// Perform commit if the flag is set
	if commitFlag {
		if err := performCommit(pano, deviceGroup, force, sleepTime); err != nil {
			log.Fatalf("Commit failed: %s", err)
		}
	}

	// Perform push if the flag is set
	if pushFlag {
		if err := performPush(pano, deviceGroup, sleepTime); err != nil {
			log.Fatalf("Push failed: %s", err)
		}
	}
}

func initializePanorama(hostname, apiKey string, timeout int) (*pango.Panorama, error) {
	pano := &pango.Panorama{
		Client: pango.Client{
			Hostname:         hostname,
			ApiKey:           apiKey,
			Logging:          pango.LogOp | pango.LogAction,
			Timeout:          timeout,
			CheckEnvironment: true,
		},
	}
	return pano, pano.Initialize()
}

func performCommit(pano *pango.Panorama, deviceGroup string, force bool, sleepTime int64) error {
	cmd := commit.PanoramaCommit{
		// Note: We have to commit "other" DG along with Cloud DG for commit to be successful
		// DeviceGroups: []string{deviceGroup},
		Description: flag.Arg(0),
		Force:       force,
	}
	sleepDuration := time.Duration(sleepTime) * time.Second

	jobID, _, err := pano.Commit(cmd, "", nil)
	if err != nil {
		return err
	}
	if jobID == 0 {
		log.Println("No commit needed")
		return nil
	}
	return waitForJob(pano, jobID, sleepDuration)
}

func performPush(pano *pango.Panorama, deviceGroup string, sleepTime int64) error {
	cmd := commit.PanoramaCommitAll{
		Type:        commit.TypeDeviceGroup,
		Description: flag.Arg(0),
		Name:        deviceGroup,
	}
	sleepDuration := time.Duration(sleepTime) * time.Second

	jobID, _, err := pano.Commit(cmd, "", nil)
	if err != nil {
		return err
	}
	if jobID == 0 {
		log.Println("No push needed")
		return nil
	}
	return waitForJob(pano, jobID, sleepDuration)
}

func waitForJob(pano *pango.Panorama, jobID uint, sleepDuration time.Duration) error {
	if err := pano.WaitForJob(jobID, sleepDuration, nil, nil); err != nil {
		return err
	}
	log.Printf("Operation with job ID %d completed successfully", jobID)
	return nil
}
