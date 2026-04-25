import Quickshell
import Quickshell.Io // for Process
import QtQuick

PanelWindow {
	anchors {
		top: true
		left: true
		right: true
	}

	implicitHeight: 30

	Text {
		// give the text an ID we can refer to elsewhere in the file
		id: clock

		anchors.centerIn: parent

		// create a process management object
		Process {
			//give the process object and id so we can talk about it from the timer
			id: dateProc

			// the command it will run, every argument is its own string
			command: ["date"]

			// run the command immediately
			running: true

			// process the stdout stream using a StdioCollector
			// Use StdioCollector to retrieve the text the process sends
			// to stdout.
			stdout: StdioCollector {
			// Listen for the streamFinished signal, which is sent
			// when the process closes stdout or exits.
				onStreamFinished: clock.text = this.text // `this` can be omitted
			}
		}
	}
	// use a timer to rerun the process at an interval
	Timer {
		// 1000 milliseconds is 1 second
		interval: 1000

		// start the timer immediately
		running: true

		// run the timer again when it ends
		repeat: true

		// when the timer is triggered, set the running property of the
		// process to true, which reruns it if stopped.
		onTriggered: dateProc.running = true
	}
}
