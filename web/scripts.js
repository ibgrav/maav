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
        info: []
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
            let a = app.info.findIndex(obj => obj.title == event);
            app.selectedInfo = app.info[a].data;
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
        },
        setResources: () => {
            for (item of app.info) {
                app.resources.push(item.title);
            }
        },
        saveInput: (event, type, item) => {
            console.log(event, ' ', app.selectedResource, ' ', type, ' ', item);

            let a = app.info.findIndex(obj => obj.title == app.selectedResource);
            let b = app.info[a].data.findIndex(obj => obj.id == item);
            app.info[a].data[b][type] = event;
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
                app.info = data;
                app.setResources();
            });
    }
    else app.authenticated = false;
    app.loading = false;
});