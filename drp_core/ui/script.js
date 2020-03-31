const DRP_AdminApp = new Vue({
    el: "#DRP_Admin",

    data: {

        // Booleans
        showMenu: false,
        playerModalActive: false,

        // Arrays
        pages: ["Chat", "Reports", "Kick", "Ban", "Whitelist"],
        players: [],
        banTypes: ["Minutes", "Hours", "Days", "Weeks", "Months", "Years"],

        // Selected Page
        currentPage: "Chat",

        // Selected Player Data
        selectedPlayer: {},

        // Chat
        messages: [], // {name: [Player Name], message: [Players Message]}
        messageToSend: "",
        muteMessageSound: false,

        // Kicking
        kickReason: "",
        
        // Banning
        banType: "",
        banAmount: 0,
        banPermanent: false,
        banReason: ""

    },

    methods: {

        // Toggling Admin Menu
        OpenAdminMenu(players) {
            this.players = players;
            this.showMenu = true;
        },

        CloseAdminMenu() {
            this.showMenu = false;
            this.selectedPlayer = {};
            axios.post("http://drp_core/close_admin_menu", {}).then( (response) => {
                console.log(response);
            }).catch( (error) => {
                console.log(error);
            })
        },

        // Changing Admin Page
        ChangePage(page) {
            this.currentPage = page;
        },

        // Players Modal
        OpenPlayerModal() {
            this.playerModalActive = true;
        },

        SelectPlayer(index) {
            this.selectedPlayer = {id: this.players[index].id, name: this.players[index].name};
            this.playerModalActive = false;
        },

        // Admin Chat
        SendMessage() {
            axios.post("http://drp_core/send_message", {message: this.messageToSend}).then( (response) => {
                console.log(response);
                this.messageToSend = "";
            }).catch( (error) => {
                console.log(error);
            });
        },

        RecieveMessage(from, message, isPlayerSender) {
            if (isPlayerSender) {
                let messageBox = document.getElementById("AdminMessageBox");
                this.messages.push({name: from, message: message});
                messageBox.scrollTop = messageBox.scrollHeight;
                if (this.messages.length >= 16) {
                    this.messages.splice(0, 1);
                };
            } else {
                let messageBox = document.getElementById("AdminMessageBox");
                this.messages.push({name: from, message: message});
                messageBox.scrollTop = messageBox.scrollHeight;
                if (this.messages.length >= 16) {
                    this.messages.splice(0, 1);
                };

                if (!this.muteMessageSound) {
                    var messageSound = new Audio("./sounds/admin_chat_notification.ogg");
                    messageSound.play();
                };
            };
        },

        // Kicking Players
        KickPlayer() {
            if (this.selectedPlayer.id != null) {
                axios.post("http://drp_core/kick_player", {
                    player: this.selectedPlayer,
                    msg: this.kickReason
                }).then( (response) => {
                    console.log(response);
                }).catch( (error) => {
                    console.log(error);
                });

                this.selectedPlayer = "";
                this.kickReason = "";
            }
        },

        // Banning Players
        BanPlayer() {
            if (this.selectedPlayer.id != null) {
                let convertedSeconds = 0;
                let perm = false
                if (!this.banPermanent) {
                    if (this.banType == "Seconds") {
                        convertedSeconds = Number(this.banAmount);
                    } else if (this.banType == "Minutes") {
                        convertedSeconds = Number(this.banAmount) * 60;
                    } else if (this.banType == "Hours") {
                        convertedSeconds = Number(this.banAmount) * 3600;
                    } else if (this.banType == "Days") {
                        convertedSeconds = Number(this.banAmount) * 86400;
                    } else if (this.banType == "Weeks") {
                        convertedSeconds = Number(this.banAmount) * 604800;
                    } else if (this.banType == "Months") {
                        convertedSeconds = Number(this.banAmount) * 2628000;
                    } else if (this.banType == "Years") {
                        convertedSeconds = Number(this.banAmount) * 31536000;
                    } else {
                        convertedSeconds = Number(this.banAmount);
                    };
                } else {
                    convertedSeconds = -1;
                    perm = true;
                };
                axios.post("http://drp_core/ban_player", {
                    player: this.selectedPlayer,
                    msg: this.banReason,
                    time: convertedSeconds,
                    perm: perm
                }).then( (response) => {
                    console.log(response);
                }).catch( (error) => {
                    console.log(error);
                });
                this.selectedPlayer = "";
                this.banType = "";
                this.banAmount = 0;
                this.banPermanent = false;
                this.banReason = ""
            }
        }
    }
});

// Listener from Lua CL
document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "open_admin_menu") {
                DRP_AdminApp.OpenAdminMenu(event.data.players);
            } else if (event.data.type == "recieve_admin_message") {
                DRP_AdminApp.RecieveMessage(event.data.name, event.data.message, event.data.isSender);
            }
        });
    };
};