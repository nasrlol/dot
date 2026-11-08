function newrepo --description 'Create a bare git repo on valencia for cgit'
    if test (count $argv) -ne 1
        echo "usage: newrepo <name>"
        return 1
    end
    set -l name (string replace -r '\.git$' '' $argv[1])
    ssh -t valencia "sudo -u git git init --bare /srv/git/$name.git"
    and echo "git@valencia:/srv/git/$name.git"
end
