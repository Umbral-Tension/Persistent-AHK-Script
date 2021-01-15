"""Script to generate and keep track of random subreddits urls.""" 

import requests 
import json
import os
import time

def getsubs(subs):
    oldsubs = subs['visited'] + subs['unvisited']
    newsubs = []
    failures = 0
    last_req = time.time()
    while len(newsubs) < 10:
        delta = time.time() - last_req
        if delta < .5:
            time.sleep(delta)
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

if __name__ == '__main__':
    BASE_DIR = os.path.dirname(__file__)
    subs_file = os.path.join(BASE_DIR, 'resources/random_subreddits.json')
    firefox = '"C:/Program Files/Mozilla Firefox/firefox.exe"'
    with open(subs_file, 'r') as f:
        subs = json.load(f)
        if len(subs['unvisited']) >= 5:
            for x in range(5):
                sub = subs["unvisited"].pop()
                subs['visited'].append(sub)
                sub_url = f'https://www.reddit.com/r/{sub}'
                firefox += ' ' + sub_url
            os.system(firefox)
        subs['unvisited'].extend(getsubs(subs))

    with open(subs_file, 'w') as f:
        json.dump(subs, f, indent=2)





