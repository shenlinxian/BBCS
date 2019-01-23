from fabric.api import *
env.hosts = 'localhost'

def hello():
    local('echo hello world')

def check():
    local('ls /Users/')

def remote():
    run('ping www.baidu.com')

