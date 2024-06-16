local text_handler = {
}

text_handler.base_path = "data/texts/"

text_handler.text_file_names = {
    words = {
        common_eng_words =  text_handler.base_path .. "words/common_eng_words.txt",
        teen_slang = text_handler.base_path .. "words/teen_slang.txt",
        weird_slang = text_handler.base_path .. "words/weird_swear_words.txt",
        wiki_swear_words = text_handler.base_path .. "words/wiki_swear_words.txt",
    },
    quotes = {
        programming_quotes_00 = text_handler.base_path .. "quotes/programming_quotes_00.txt"
    }
}

text_handler.words_list = {}

text_handler.quotes_list = {}

-- used to read individual words in the data/words folder
function text_handler.read_text_file_to_table(file_name)
    -- if we don't have the words args
    -- Open the file in read mode
    local file, err = io.open(file_name, "r")
    -- local file, err = io.open(text_handler.text_file_names.common_eng_words, "r")
    -- local file, err = io.open(text_handler.text_file_names.wiki_swear_words, "r")
    -- local file, err = io.open(text_handler.text_file_names.programming_quotes_00, "r")

   -- Check for errors
   if not file then
       error("Error opening file: " .. err)
   end
   -- read individual words and insert into the words list
    for line in file:lines() do
        table.insert(text_handler.words_list, line)
    end

   file:close()
   text_handler.print_out_words_list_quotes()
end

function text_handler.print_out_words_list_raw()
    for i, line in ipairs(text_handler.words_list) do
        -- prints every line
            print("Line " .. i .. ": " .. line) -- prints entire line
        end
end

function text_handler.print_out_words_list_quotes()
    -- Print the lines to the console (for verification)
    for i, line in ipairs(text_handler.words_list) do
            -- Extract quote between double quotes etc. "some qoute "
            local quote = line:match('"([^"]+)"')
            -- Extract author after "some qoute" - author name...  etc. + context
            local author = line:match('Author:%s*(.-)$')
            if quote and author then
                print(quote .. " - " .. author) -- prints the extracted quote without the double quotes
            elseif quote and not author then
                print("quote: " .. quote) -- prints the extracted quote without the double quotes 
            end
        end
end

function text_handler.split_quote_and_author()
    for i, line in ipairs(text_handler.words_list) do
        -- Extract quote between double quotes etc. "some qoute "
        local quote = line:match('"([^"]+)"')
        -- Extract author after "some qoute" - author name...  etc. + context
        local author = line:match('Author:%s*(.-)$')
        if quote and author then
            local new_element = {
                quote = quote,
                author = author
             }
            table.insert(text_handler.quotes_list, new_element)
            print(quote .. " - " .. author) -- prints the extracted quote without the double quotes
        elseif quote and not author then
            local new_element = {
                quote = quote,
                author = "Unknown"
             }
            table.insert(text_handler.quotes_list, new_element)
            print("quote: " .. quote) -- prints the extracted quote without the double quotes 
        end
    end
end


return text_handler