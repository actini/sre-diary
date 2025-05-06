# !/bin/zsh

ROOT="$(dirname "$(realpath "$0/..")")"
ACTION=$1

case $ACTION in
  "new")
  DIARY=$2
  mkdir -p $ROOT/codebook/$DIARY
  mkdir -p $ROOT/notebook/assets/$DIARY
  touch $ROOT/notebook/$DIARY.md
  git checkout master && git pull --all
  git checkout -b $DIARY && git add $ROOT/notebook/$DIARY.md
  git commit -m "Add $DIARY" && git push -u origin $DIARY
  ;;
  "del")
  DIARY=$2
  rm -rf $ROOT/codebook/$DIARY
  rm -rf $ROOT/notebook/assets/$DIARY
  rm $ROOT/notebook/$DIARY.md
  ;;
  "rename")
  DIARY=$2
  NAME=$3
  mv $ROOT/codebook/$DIARY $ROOT/codebook/$NAME
  mv $ROOT/notebook/assets/$DIARY $ROOT/notebook/assets/$NAME
  mv $ROOT/notebook/$DIARY.md $ROOT/notebook/$NAME.md
  ;;
  "replace")
  STR1=$2
  STR2=$3
  find $ROOT -type f -not -path '*.git/*' -not -path '*/assets/*' -exec sed -i '' -E "s/$STR1/$STR2/g" {} \;
  ;;
esac
