#!/usr/bin/env bash
export OUTPUT_DIR=$(date '+%Y-%m-%d')
cd $HOME/git_checkouts/curriculum-team/issues_output
bash $HOME/git_checkouts/curriculum_tools/ops_summary.sh $HOME/git_checkouts/curriculum_tools/lesson_lists
mkdir $OUTPUT_DIR
mv $HOME/git_checkouts/curriculum_tools/lesson_lists/*_issues.md $OUTPUT_DIR
pushd $OUTPUT_DIR
wc -l * > summary.txt
popd
mv $OUTPUT_DIR $HOME/git_checkouts/curriculum-team/issues_output
cd $HOME/git_checkouts/curriculum-team/issues_output/${OUTPUT_DIR}
GIT_SSH_COMMAND="ssh -i $HOME/.ssh/automated-github" /usr/bin/git pull origin master
git add .
git commit -m "${OUTPUT_DIR} Automated Issue Tracking Results"
GIT_SSH_COMMAND="ssh -i $HOME/.ssh/automated-github" /usr/bin/git push origin master > /dev/null 2>&1
echo "Finished. Visit https://github.com/learn-co-curriculum/curriculum-team/tree/master/issues_output/${OUTPUT_DIR}" | mailx -s "Finished issues track update" se-academics@flatironschool.com > /dev/null 2>&1
