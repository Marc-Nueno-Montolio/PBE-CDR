window.addEventListener("load", function () {

    var uid = getCookie("uid")
    var name = getCookie("name")
    if (uid == "") {
        showLogin()
    } else {
        showDashboard(uid, name)
    }

});

function login(form) {
    const XHR = new XMLHttpRequest();
    const FD = new FormData(form);

    var uid = FD.get('uid')
    var name = FD.get('username')
    var query = "http://138.68.152.226:3000/students?uid=" + String(uid)

    XHR.addEventListener("load", function (event) {
        if (this.status === 200 && this.response != "ERROR") {
            let res = JSON.parse(this.response);

            if (res.name == name && res.uid == uid) {
                // User Logged In
                document.getElementById('loginErrors').style.display = 'none';

                // Go To Dashboard = uid =
                document.cookie = "uid=" + uid;
                document.cookie = "name=" + name;
                showDashboard(uid, name)
            } else {
                // Display login errors
                document.getElementById('loginErrors').style.display = 'block';
            }

        } else {
            // Display login errors
            document.getElementById('loginErrors').style.display = 'block';
        }
    });

    // Set up and send our request asynchronously
    XHR.open("GET", query, true);
    XHR.send();
}

function showLogin() {
    let xhr = new XMLHttpRequest();
    xhr.open('get', 'login.html', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById("mainContent").innerHTML = xhr.responseText;

            const form = document.getElementById("loginForm");

            form.addEventListener("submit", function (event) {
                event.preventDefault(); // Prevent Page Reload
                login(form);
            });
        }
    }
    xhr.send();
}

function showDashboard(uid, name) {
    let xhr = new XMLHttpRequest();
    xhr.open('get', 'dashboard.html', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById("mainContent").innerHTML = xhr.responseText;

            document.getElementById('welcomeText').innerText = name;


            // Send Query
            const sendQueryBtn = document.getElementById("sendQueryBtn");
            sendQueryBtn.addEventListener("click", function (event) {
                let query = document.getElementById("searchBar").value;
                sendQuery(query, uid)
            });


            // Logout
            const logoutBtn = document.getElementById("logoutBtn");
            logoutBtn.addEventListener("click", function (event) {
                document.cookie = "uid="
                document.cookie = "name="
                showLogin()
            });
        }
    }
    xhr.send();
}

function sendQuery(query, uid) {
    const XHR = new XMLHttpRequest();

    if(!(query.includes('tasks') || query.includes('timetables') || query.includes('marks'))){
        document.getElementById('query_err').style.display = 'block'
    }else{
        document.getElementById('query_err').style.display = 'none'
    }
    console.log(query)

    let str = ""
    if (query.includes('?')) {
        str = "http://138.68.152.226:3000/" + query + "&uid=" + uid
    } else {
        str = "http://138.68.152.226:3000/" + query + "?uid=" + uid
    }

    XHR.addEventListener("load", function (event) {
        if (this.status === 200 && this.response != "ERROR") {
            let data = JSON.parse(this.response)


            document.getElementById('queryTable').innerText = str

            renderTable(data)


        } else {

        }
    });

    // Set up and send our request asynchronously
    XHR.open("GET", str, true);
    XHR.send();
}

function renderTable(data) {
    console.log(data)

    let keys = [];
    for (let k in data[0]) keys.push(k);

    str = "<tr>"
    for (let i in keys) {
        str += "<th>" + keys[i] + "</th>"
    }
    str += "</tr>"

    for (let i in data) {
        str += "<tr>"
        for (let k in keys) {
            str += "<td>" + data[i][keys[k]] + "</td>"

        }
        str += "</tr>"

    }

    document.getElementById('resultsTable').innerHTML = str;

}

// Copied from W3Schools.com (to check cookies)
function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}