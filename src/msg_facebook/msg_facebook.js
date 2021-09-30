const fs = require("fs");
const login = require("facebook-chat-api");

login({appState: JSON.parse(fs.readFileSync('/data/appstate.json', 'utf8'))}, (err, api) => {
    if(err) return console.error(err);

    api.sendMessage({ body: process.env.FB_MESSAGE }, process.env.FB_THREAD_ID, function(){
        api.sendMessage({ attachment: fs.createReadStream('/data/workdir/current.png') }, process.env.FB_THREAD_ID, function(){
            if (process.env.diff_exitcode == 1) {
                api.sendMessage({ attachment: fs.createReadStream('/data/workdir/comparison.png') }, process.env.FB_THREAD_ID, function(){
                    api.sendMessage({ attachment: fs.createReadStream('/data/workdir/' + process.env.pdf_nice) }, process.env.FB_THREAD_ID);
                });
            } else api.sendMessage({ attachment: fs.createReadStream('/data/workdir/' + process.env.pdf_nice) }, process.env.FB_THREAD_ID);
        });
    });
});