var infoRef = firebase.storage().ref().child('data.txt');

var app = new Vue({
    el: '#app',
    data: {
        loading: true,
        authBtn: "",
        alert: true,
        passError: false,
        authenticated: false,
        search: null,
        resources: [],
        selectedResource: '',
        selectedInfo: [],
        resourceHeads: [{
            "text": "Title", "value": "title"
        }, {
            "text": "Phone", "value": "phone"
        }, {
            "text": "TTY", "value": "tty"
        }, {
            "text": "Website", "value": "web"
        }, {
            "text": "Blurb", "value": "blurb"
        }],
        info: [{
            "title": "Emergency",
            "data": [{
                "title": "Call 911",
                "phone": "911",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Domestic Violence Officer",
                "phone": "(781) 979-4432",
                "tty": "",
                "web": "",
                "blurb": ""
            }]
        }, {
            "title": "Support Services",
            "data": [{
                "title": "Alliance Against Violence",
                "phone": "(781) 662-2010",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Riverside Counseling Center",
                "phone": "(781) 246-2010",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Respond",
                "phone": "(617) 623-5900",
                "tty": "",
                "web": "",
                "blurb": ""
            }]
        }, {
            "title": "Hotlines/Helplines",
            "data": [{
                "title": "Teen Dating Abuse Helpline",
                "phone": "1-866-331-9474",
                "tty": "1-866-331-8453",
                "web": "",
                "blurb": ""
            }, {
                "title": "National Domestic Violence Hotline",
                "phone": "1-800-799-7233",
                "tty": "1-800-787-3224",
                "web": "",
                "blurb": ""
            }, {
                "title": "AIDS Center for Disease Control",
                "phone": "1-800-CDC-INFO",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Alateen",
                "phone": "1-508-366-0556",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Boston Area Rape Crisis",
                "phone": "1-800-841-8371",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "National Child Abuse Hotline",
                "phone": "1-800-422-4453",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Drug Abuse",
                "phone": "1-877-553-TEEN",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Gay & Lesbian Youth Peer Listening",
                "phone": "1-800-399-PEER",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Suicide-SamariTeens",
                "phone": "1-800-252-TEEN",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "National Runaway Safeline",
                "phone": "1-800-786-2929",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "National Suicide Prevention Lifeline",
                "phone": "1-800-273-8255",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "Samaritans statewide Helpline",
                "phone": "1-877-870-4673",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "The Trevor Project (hotline for LGBTQ Youth",
                "phone": "1-899-488-7386",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "The Network/La Red (LGBTQ community)",
                "phone": "1-800-832-1901",
                "tty": "",
                "web": "",
                "blurb": ""
            }, {
                "title": "SafeLink",
                "phone": "1-877-785-2020",
                "tty": "",
                "web": "",
                "blurb": ""
            }]
        }, {
            "title": "Help for Abusers",
            "data": [{
                "title": "Emerge",
                "phone": "(617) 547-9879",
                "tty": "",
                "web": "",
                "blurb": ""
            }]
        }, {
            "title": "Websites",
            "data": [{
                "title": "",
                "phone": "",
                "tty": "",
                "web": "loveisrespect.org",
                "blurb": ""
            }, {
                "title": "",
                "phone": "",
                "tty": "",
                "web": "chooserespect.org",
                "blurb": ""
            }, {
                "title": "",
                "phone": "",
                "tty": "",
                "web": "thesafespace.org",
                "blurb": ""
            }]
        }]
    },
    async created() {
        for (item of this.info) {
            this.resources.push(item.title);
        }
    },
    updated: function () {
        this.$nextTick(function () {
            // this.loading = false;
        })
    },
    methods: {
        auth: async () => {
            app.loading = true;
            await firebase.auth().signInWithEmailAndPassword('ibgrav@gmail.com', document.body.querySelector('#pass').value).catch(function (error) {
                console.log(error);
                this.passError = true;
            });
            app.loading = false;
        },
        chooseResource: (event) => {
            app.selectedResource = event;
            for (item of app.info) {
                if (item.title == event) app.selectedInfo = item.data;
            }
        },
        editItem: (event) => {
            console.log(event);
        },
        updateStorage: async () => {
            app.loading = true;
            var blob = new Blob([JSON.stringify(app.info)], { type: 'text' });
            var time = new Date();
            var timestamp = (time.toLocaleDateString() + ' ' + time.toLocaleTimeString()).replace(/\//g, '-');
            var backupRef = firebase.storage().ref().child(timestamp + '.txt');
            await infoRef.put(blob).then(function (snapshot) {
                console.log('Uploaded ', app.info);
            });
            await backupRef.put(blob).then(function (snapshot) {
                console.log('Uploaded ' + timestamp);
            });
            app.loading = false;
        }
    }
});

firebase.auth().onAuthStateChanged(async function (user) {
    app.loading = true;
    if (user) {
        var fetchurl = '';
        app.authenticated = true;
        await infoRef.getDownloadURL().then(function (url) {
            fetchurl = url;
        });
        console.log(fetchurl)
        await fetch(fetchurl).then(res => res.json())
            .then((data) => {
                console.log(data);
            });
    }
    else app.authenticated = false;

    app.loading = false;
});