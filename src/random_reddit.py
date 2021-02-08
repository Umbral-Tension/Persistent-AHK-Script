"""Script to generate and keep track of random subreddits urls.""" 

import requests 
import json
import os
import time
import sys
from jtools.jconsole import exit_app
import threading

BASE_DIR = os.path.dirname(__file__)
MINER_SUBS_FILE = os.path.join(BASE_DIR, 'resources/mined_random_subreddits.json')
OPENER_SUBS_FILE = os.path.join(BASE_DIR, 'resources/random_subreddits.json')
def mine(num=1000):
    merge_subs_files()
    with open(MINER_SUBS_FILE, 'r') as f:
        subs = json.load(f)
    num_unvisited = len(subs['unvisited'])
    def status():
        print(f"{time.ctime()}\n\tgathered {num_unvisited} of {num}'")
        if num_unvisited < num:
            threading.Timer(600, status).start()
    status()
    while(num_unvisited < num):
        newsubs = getsubs(subs, 20)
        subs['unvisited'].extend(newsubs)
        try: 
            with open(MINER_SUBS_FILE, 'w') as f:
                json.dump(subs, f, indent=4)
                num_unvisited += len(newsubs)
        except:
            pass

        
def merge_subs_files():
    with open(MINER_SUBS_FILE, 'r+') as f1:
        miner = json.load(f1)
        with open(OPENER_SUBS_FILE, 'r+') as f2:
            opener = json.load(f2)

            miner['unvisited'] = list( 
                set(miner['unvisited']).difference(set(opener['visited']))
                )
            miner['visited'] = opener['visited']

            f1.seek(0)
            f1.truncate()
            f2.seek(0)
            f2.truncate()
            json.dump(miner, f1, indent=4)
            json.dump(miner, f2, indent=4)
    
    

def getsubs(subs, num):
    oldsubs = subs['visited'] + subs['unvisited']
    newsubs = []
    failures = 0
    last_req = time.time()
    while len(newsubs) < 10:
        delta = time.time() - last_req
        if delta < 3:
            time.sleep(3.0-delta)
        last_req = time.time()
        r = requests.get('https://reddit.com/r/random', headers={'user-agent':'random_sub_grabber pls let me have them'})
        if r.ok:
            subreddit = extract_sub(r.url)
            if subreddit in oldsubs:
                continue
            newsubs.append(subreddit)
        else:
            failures += 1
            if failures > 4: 
                break
    return newsubs
            

def extract_sub(url):
    s = url.replace('https://www.reddit.com/r/', '')
    s = s[ : s.index('/')]
    return s

def opensubs():
    firefox = '"C:/Program Files/Mozilla Firefox/firefox.exe"'
    with open(OPENER_SUBS_FILE, 'r') as f:
        subs = json.load(f)
        if len(subs['unvisited']) >= 5:
            for x in range(5):
                sub = subs["unvisited"].pop()
                subs['visited'].append(sub)
                sub_url = f'https://www.reddit.com/r/{sub}'
                firefox += ' ' + sub_url
            os.system(firefox)
        else:
            exit_app('Not enough subs left in the piggy bank.')

    with open(OPENER_SUBS_FILE, 'w') as f:
        json.dump(subs, f, indent=4)


if __name__ == '__main__':
    if len(sys.argv)>1:
        if(sys.argv[1] == '-mine'):
            mine()
    else:
        opensubs()






