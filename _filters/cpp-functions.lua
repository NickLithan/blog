-- Language classes which should use the custom C++ highlighter.
local cpp_aliases = {
  ["cpp"]    = true,
  ["c++"]    = true,
  ["cxx"]    = true,
  ["cc"]     = true,
  ["isocpp"] = true,
  ["hpp"]    = true,
  ["hxx"]    = true,
  ["hh"]     = true
}

local custom_class = "cpp-functions"


local function has_class(classes, wanted)
  for _, class_name in ipairs(classes) do
    if class_name == wanted then
      return true
    end
  end

  return false
end


local function is_cpp_block(classes)
  for _, class_name in ipairs(classes) do
    if cpp_aliases[string.lower(class_name)] then
      return true
    end
  end

  return false
end


local function add_custom_highlighter(classes)
  if has_class(classes, custom_class) then
    return false
  end

  if not is_cpp_block(classes) then
    return false
  end

  -- Pandoc tries language classes in order. Put our custom grammar first,
  -- but retain "cpp" so that Quarto and editor-related behavior still sees
  -- the original language class.
  table.insert(classes, 1, custom_class)

  return true
end


function CodeBlock(block)
  if add_custom_highlighter(block.classes) then
    return block
  end
end


function Code(code)
  if add_custom_highlighter(code.classes) then
    return code
  end
end
