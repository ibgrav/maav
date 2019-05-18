var stagingRef = firebase.storage().ref().child('staging.json');
var masterRef = firebase.storage().ref().child('master.json');

var app = new Vue({
    el: '#app',
    data: {
        loading: true,
        authBtn: "",
        alert: true,
        passError: false,
        authenticated: false,
        dialog: false,
        editEntry: false,
        search: null,
        resources: [],
        selectedResource: '',
        selectedIndex: null,
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
        info: [],
        newResource: {
            "title": "",
            "phone": "",
            "tty": "",
            "web": "",
            "blurb": ""
        },
        editResource: {
            "id":"",
            "title": "",
            "phone": "",
            "tty": "",
            "web": "",
            "blurb": ""
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
            let a = app.info.findIndex(obj => obj.title == event);
            app.selectedIndex = a;
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
            var backupRef = firebase.storage().ref().child('/backup').child(timestamp + '.json');
            await stagingRef.put(blob).then(function (snapshot) {
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
            // let a = app.info.findIndex(obj => obj.title == app.selectedResource);
            let b = app.info[app.selectedIndex].data.findIndex(obj => obj.id == item);
            app.info[app.selectedIndex].data[b][type] = event;
            console.log(JSON.stringify(app.info[app.selectedIndex].data[b]));
        },
        addCategory: () => {

        },
        addResource: () => {
            // let a = app.info.findIndex(obj => obj.title == app.selectedResource);
            app.newResource.id = app.info[app.selectedIndex].data.length;
            app.info[app.selectedIndex].data.push(app.newResource);
            app.resetNewResource();
            app.dialog = false;
            console.log(app.info[app.selectedIndex]);
        },
        resetNewResource: () => {
            app.newResource = {
                "id":"",
                "title": "",
                "phone": "",
                "tty": "",
                "web": "",
                "blurb": ""
            }
            app.editResource = {
                "id":"",
                "title": "",
                "phone": "",
                "tty": "",
                "web": "",
                "blurb": ""
            }
        },
        editCurrentEntry: (id) => {
            let a = app.info[app.selectedIndex].data.findIndex(obj => obj.id == id);
            app.editResource = app.info[app.selectedIndex].data[a];
            app.editEntry = true;
        },
        deleteEntry: () => {
            
        }
    }
});

firebase.auth().onAuthStateChanged(async function (user) {
    app.loading = true;
    if (user) {
        var fetchurl = '';
        app.authenticated = true;
        await stagingRef.getDownloadURL().then(function (url) {
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