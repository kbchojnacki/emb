const util = require('util');
const exec = util.promisify(require('child_process').exec);
const path = require('path');
const dir = path.dirname(require.main.filename);

const isWin = process.platform === "win32";
const isLin = process.platform === "linux";

const sleep = (time) => new Promise((res,rej) => setTimeout(() => res(),time));

console.log(dir)
const initdb = dir+(isWin?"/pgsql/win/bin/initdb.exe":isLin?"/pgsql/lin/bin/initdb":"/pgsql/osx/bin/initdb");
const pg_ctl = dir+(isWin?"/pgsql/win/bin/pg_ctl.exe":isLin?"/pgsql/lin/bin/pg_ctl":"/pgsql/osx/bin/pg_ctl");

const rm = (file) => exec('rm -rf ' + dir + '/' + file);
const clean = async () => { await rm('data');await rm('logfile')};
const init = () => exec(initdb+' -A  trust -U postgres -D'+dir + '/data -E UTF-8');
const start = () => exec(pg_ctl+' -D' + dir+ '/data -l logfile start');
const stop = () => exec(pg_ctl+' -D' + dir + '/data -l logfile stop');

const test = async () => {
    await clean();
    console.log((await init()).stdout)
    console.log((await start()).stdout)
    await sleep(10000);
    console.log((await stop()).stdout)
    await clean();
}

test();

