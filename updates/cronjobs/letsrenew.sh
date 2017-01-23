#!/bin/bash
/opt/letsencrypt/letsencrypt-auto renew --standalone --pre-hook "service nginx stop" --post-hook "service nginx start" >> /var/log/le-renew.log
