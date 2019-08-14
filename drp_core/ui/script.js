
const Notification = new Vue({
    el: "#DRPNotifications",

    methods: {
        CustomURLIconNotification(title, body, time, url, showBar, pos) {
            this.$snotify.simple(body, title, {
                timeout: time,
                showProgressBar: showBar,
                closeOnClick: false,
                position: pos,
                icon: url
            })
        },

        CustomIconNotification(title, body, time, iconFile, showBar, pos) {
            this.$snotify.simple(body, title, {
                timeout: time,
                showProgressBar: showBar,
                closeOnClick: false,
                position: pos,
                icon: "../icons/" + iconFile
            })
        },

        SuccessNotification(title, body, time, showBar, pos) {
            this.$snotify.success(body, title, {
                timeout: time,
                showProgressBar: showBar,
                closeOnClick: false,
                position: pos
            })
        },

        ErrorNotification(title, body, time, showBar, pos) {
            this.$snotify.error(body, title, {
                timeout: time,
                showProgressBar: showBar,
                closeOnClick: false,
                position: pos
            })
        },

        WarningNotification(title, body, time, showBar, pos) {
            this.$snotify.warning(body, title, {
                timeout: time,
                showProgressBar: showBar,
                closeOnClick: false,
                position: pos
            })
        },

        InfoNotification(title, body, time, showBar, pos) {
            this.$snotify.info(body, title, {
                timeout: time,
                showProgressBar: showBar,
                closeOnClick: false,
                position: pos
            })
        }
    }
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {

            if (event.data.type == "notification_customurlicon") {

                Notification.CustomURLIconNotification(event.data.title, event.data.body, event.data.time, event.data.url, event.data.showBar, event.data.pos);

            } else if (event.data.type == "notification_customicon") {

                Notification.CustomIconNotification(event.data.title, event.data.body, event.data.time, event.data.iconFile, event.data.showBar, event.data.pos);

            } else if (event.data.type == "notification_success") {

                Notification.SuccessNotification(event.data.title, event.data.body, event.data.time, event.data.showBar, event.data.pos);

            } else if (event.data.type == "notification_error") {

                Notification.ErrorNotification(event.data.title, event.data.body, event.data.time, event.data.showBar, event.data.pos);

            } else if (event.data.type == "notification_warning") {

                Notification.WarningNotification(event.data.title, event.data.body, event.data.time, event.data.showBar, event.data.pos);

            } else if (event.data.type == "notification_info") {

                Notification.InfoNotification(event.data.title, event.data.body, event.data.time, event.data.showBar, event.data.pos);

            }

        });
    };
};