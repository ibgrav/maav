var app = new Vue({
    el: '#app',
    data: {
        loading: true,
        authBtn: "",
        alert: true,
        passError: false,
        authenticated: false
    },
    async created() {

    },
    updated: function () {
        this.$nextTick(function () {
            this.loading = false;
        })
    },
    methods: {
        auth: async () => {
            this.loading = true;
            await firebase.auth().signInWithEmailAndPassword('ibgrav@gmail.com', document.body.querySelector('#pass').value).catch(function (error) {
                console.log(error);
                this.passError = true;
            });
            this.loading = false;
        }
    }
});

firebase.auth().onAuthStateChanged(function (user) {
    if(user) app.authenticated = true;
    else app.authenticated = false;
    app.loading = false;
});