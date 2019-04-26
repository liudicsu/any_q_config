file_dir=/home/search
echo "question	answer" > ${file_dir}/AI/post_query.txt
cat ${file_dir}/AI/query.txt |uniq|sort|uniq >> ${file_dir}/AI/post_query.txt
cp ${file_dir}/AI/post_query.txt  ${file_dir}/fashionchat/configs/query.txt
find ${file_dir}/AI -type f |xargs -n 1 dos2unix 
cp ${file_dir}/AI/post_query.txt  ${file_dir}/AnyQ/build/solr_script/sample_docs
python ${file_dir}/AnyQ/build/solr_script/make_json.py ${file_dir}/AnyQ/build/solr_script/sample_docs ${file_dir}/AnyQ/build/faq/schema_format ${file_dir}/AnyQ/build/faq/faq_json

awk -F "\t" '{print ++ind"\t"$0}' ${file_dir}/AnyQ/build/faq/faq_json > ${file_dir}/AnyQ/build/faq/faq_json.index

cp ${file_dir}/analysis.conf.pre    ${file_dir}/AnyQ/build/example/conf/analysis.conf    
cp ${file_dir}/dict.conf.pre        ${file_dir}/AnyQ/build/example/conf/dict.conf     
cp ${file_dir}/retrieval.conf.pre   ${file_dir}/AnyQ/build/example/conf/retrieval.conf

${file_dir}/AnyQ/build/annoy_index_build_tool ${file_dir}/AnyQ/build/example/conf/ ${file_dir}/AnyQ/build/example/conf/analysis.conf ${file_dir}/AnyQ/build/faq/faq_json.index 128 10 ${file_dir}/AnyQ/build/semantic.annoy 1>std 2>err

cp ${file_dir}/AnyQ/build/faq/faq_json.index ${file_dir}/AnyQ/build/semantic.annoy ${file_dir}/AnyQ/build/example/conf

cp ${file_dir}/dict.conf.post        ${file_dir}/AnyQ/build/example/conf/dict.conf     
cp ${file_dir}/retrieval.conf.post   ${file_dir}/AnyQ/build/example/conf/retrieval.conf
ps axu|grep ./run_server|grep -v grep | awk  '{print $2}' |xargs -n 1  kill 
cd ${file_dir}/AnyQ/build/
nohup ./run_server  >run_log  2>&1  &
