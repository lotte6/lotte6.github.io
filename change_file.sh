#!/bin/bash
toFirstLetterUpper2() {
  str=$1
  firstLetter=`echo ${str:0:1} | awk '{print toupper($0)}'`
  otherLetter=${str:1}
  result=$firstLetter$otherLetter
}

for f in `ls`;do
	toFirstLetterUpper2 $f
	echo $result
	gsed -i "s/categories.*/categories: $result/" $f/*
    for i in `ls $f`;do
	echo "___________________________________________________$f/$i"
        gsed -i '/title/i\layout: post' $f/$i
        gsed -i '/tag: hide/d' $f/$i
        gsed -i '/tags/a\description:' $f/$i
        gsed -i '/tags/a\keywords:' $f/$i
        dd=`grep date: $f/$i|awk '{print $2}'`
        mv $f/$i $f/$dd-$i
    done
done

