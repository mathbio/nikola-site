How to set up a Nikola environment
==================================

We describe step-by-step how to get a Nikola site using ipython notebooks as sources up and running.

* install virtualenv: http://www.virtualenv.org/en/latest/virtualenv.html#installation
* create virtualenv: `virtualenv nikolapy`
* install packages: `nikolapy/bin/pip install nikola jinja2 ipython`

or, to install the latest version of Nikola (from git - this is actually recommended by the developers):

    git clone git://github.com/getnikola/nikola.git
    nikolapy/bin/pip install nikola/

* it may be useful to permanently `alias nikola=$PWD/nikolapy/bin/nikola`
* install pandoc: http://johnmacfarlane.net/pandoc/installing.html (on arch,
install `pandoc-static` from the AUR)

This finishes the necessary software for Nikola. Now we have to grab the files
from the project.

* install git: http://git-scm.com/book/en/Getting-Started-Installing-Git

The following assumes you have already configured your github account.

* clone the source repo: `git clone git@github.comgit@github.com:mathbio/nikola-site`
* clone the blog repo:
`git clone git@github.comgit@github.com:mathbio/mathbio.github.io $HOME/mathbio.github.io`

Notice that we require the blog repo to be in a specific location, because
that is where nikola is going to build the site.

We are now ready to build:

    cd nikola-site
    nikola build

And now the contents of the `mathbio.github.io` folder should be updated to
reflect the content of the source files.

Creating new posts
==================

To add a post, create your ipython notebook in the usual way, then:

    cd nikola-site
    nikola new_post -f ipynb -t "The title of the post"

This command creates two new files inside the `posts/` folder, one with a `.meta` and another with a `.ipynb` extension. Replace the latter with your notebook (notice that the name should be the same). Now run

    nikola build

and, if everything went right, the new post is built. Let's see if everything is still in order: run

    nikola serve

and point your browser to http://127.0.0.1:8000 (this is your own computer!). Check that the site looks normal and your post showed up fine. Then you can kill the `nikola serve` process (hit Ctrl-C).

Finally we have to sync the github repos. Of course, you can only push to repos where you have permission to do so. We are still in the `nikola-site` folder, so let us do it first:

    git add posts/*
    git commit -m "Adding post foo..."
    git push

and now we sync the pages repo:

    cd $HOME/mathbio.github.io
    git add --all .
    git commit -m "Adding post foo..."
    git push

And that's it! After a few minutes the site should reflect your changes.

