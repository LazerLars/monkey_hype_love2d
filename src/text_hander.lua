local text_handler = {
    test = "123"
}


text_handler.base_path = "data/texts/words/"

text_handler.text_file_names = {
    common_eng_words =  text_handler.base_path .. "common_eng_words.txt",
    teen_slang = text_handler.base_path .. "teen_slang.txt",
    weird_slang = text_handler.base_path .. "weird_swear_words.txt",
    wiki_swear_words = text_handler.base_path .. "wiki_swear_words.txt"
}

text_handler.words_list = {}

function text_handler.read_text_file_to_table()
    -- Open the file in read mode
   local file, err = io.open(text_handler.text_file_names.wiki_swear_words, "r")
   local file, err = io.open(text_handler.text_file_names.common_eng_words, "r")

   -- Check for errors
   if not file then
       error("Error opening file: " .. err)
   end

   -- Read lines and insert them into the table
   for line in file:lines() do
       table.insert(text_handler.words_list, line)
   end

   -- Close the file
   file:close()

   -- Print the lines to the console (for verification)
   for i, line in ipairs(text_handler.words_list) do
       print("Line " .. i .. ": " .. line)
   end
end

return text_handler