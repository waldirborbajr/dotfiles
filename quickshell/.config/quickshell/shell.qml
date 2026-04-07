import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // ============================================================
    // THEME
    // ============================================================
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colPurple: "#ad8ee6"
    property color colRed: "#f7768e"
    property color colYellow: "#e0af68"
    property color colBlue: "#7aa2f7"
    property color colGreen: "#9ece6a"

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    // ============================================================
    // SYSTEM STATE
    // ============================================================
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0
    property int volumeLevel: 0

    property string wifiName: "Offline"
    property bool wifiConnected: false

    property bool bluetoothOn: false

    // CPU tracking
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    // ============================================================
    // CPU
    // ============================================================
    Process {
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return

                let p = data.trim().split(/\s+/)
                let total = p.slice(1).reduce((a,b)=>a+parseInt(b||0),0)
                let idle = parseInt(p[4]) + parseInt(p[5])

                if (root.lastCpuTotal > 0) {
                    let diff = total - root.lastCpuTotal
                    let idleDiff = idle - root.lastCpuIdle
                    root.cpuUsage = Math.round(100 * (diff - idleDiff) / diff)
                }

                root.lastCpuTotal = total
                root.lastCpuIdle = idle
            }
        }
    }

    // ============================================================
    // MEMORY
    // ============================================================
    Process {
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: d => {
                if (!d) return
                let p = d.trim().split(/\s+/)
                root.memUsage = Math.round((p[2] / p[1]) * 100)
            }
        }
    }

    // ============================================================
    // DISK
    // ============================================================
    Process {
        command: ["sh", "-c", "df / | tail -1"]
        stdout: SplitParser {
            onRead: d => {
                if (!d) return
                root.diskUsage = parseInt(d.split(/\s+/)[4]) || 0
            }
        }
    }

    // ============================================================
    // VOLUME
    // ============================================================
    Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: d => {
                let m = d.match(/([\d.]+)/)
                if (m) root.volumeLevel = Math.round(m[1] * 100)
            }
        }
    }

    // ============================================================
    // WIFI
    // ============================================================
    Process {
        command: ["sh", "-c", "iwgetid -r"]
        stdout: SplitParser {
            onRead: d => {
                root.wifiName = d ? d.trim() : "Offline"
                root.wifiConnected = !!d
            }
        }
    }

    // ============================================================
    // BLUETOOTH
    // ============================================================
    Process {
        command: ["sh", "-c", "bluetoothctl show | grep Powered"]
        stdout: SplitParser {
            onRead: d => {
                root.bluetoothOn = d.includes("yes")
            }
        }
    }

    // ============================================================
    // TIMER (optimized polling)
    // ============================================================
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            for (let p of root.children.filter(c => c instanceof Process))
                p.running = true
        }
    }

    // ============================================================
    // PANEL
    // ============================================================
    Variants {
        model: Quickshell.screens

        PanelWindow {
            screen: modelData
            anchors { top: true; left: true; right: true }
            implicitHeight: 30
            color: root.colBg

            RowLayout {
                anchors.fill: parent
                spacing: 8

                Item { width: 6 }

                // =========================
                // CPU
                // =========================
                Text {
                    text: " " + root.cpuUsage + "%"
                    color: root.colYellow
                    font.family: root.fontFamily
                }

                // =========================
                // MEMORY
                // =========================
                Text {
                    text: "󰍛 " + root.memUsage + "%"
                    color: root.colCyan
                    font.family: root.fontFamily
                }

                // =========================
                // DISK
                // =========================
                Text {
                    text: " " + root.diskUsage + "%"
                    color: root.colBlue
                    font.family: root.fontFamily
                }

                // =========================
                // WIFI
                // =========================
                Text {
                    text: root.wifiConnected ? " " + root.wifiName : "󰖪 Offline"
                    color: root.wifiConnected ? root.colGreen : root.colRed
                    font.family: root.fontFamily
                }

                // =========================
                // BLUETOOTH
                // =========================
                Text {
                    text: root.bluetoothOn ? " On" : " Off"
                    color: root.bluetoothOn ? root.colBlue : root.colMuted
                    font.family: root.fontFamily
                }

                // =========================
                // VOLUME
                // =========================
                Text {
                    text: {
                        if (root.volumeLevel == 0) return " 0%"
                        if (root.volumeLevel < 50) return " " + root.volumeLevel + "%"
                        return " " + root.volumeLevel + "%"
                    }
                    color: root.colPurple
                    font.family: root.fontFamily
                }

                Item { Layout.fillWidth: true }

                // =========================
                // CLOCK
                // =========================
                Text {
                    id: clock
                    text: Qt.formatDateTime(new Date(), "HH:mm  dd/MM")
                    color: root.colCyan
                    font.family: root.fontFamily

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm  dd/MM")
                    }
                }

                Item { width: 6 }
            }
        }
    }
}
