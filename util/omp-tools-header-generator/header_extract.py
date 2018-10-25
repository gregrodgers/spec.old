import re

paths = ["tool_support_common.tex", "wait_id.tex", "frames.tex", "thread_states.tex", "tool_support_entrypoints.tex", "start_tool.tex", "tool_support_callbacks.tex",]
paths.extend(["tool_support_debug.tex", "ompd_dll.tex", "ompd/ompd_activating_a_third_party_tool.tex", "ompd/ompd_introduction.tex", "ompd/ompd_third_party_callback_interface.tex", "ompd/ompd_data_types_for_third_party_tools.tex", "ompd/ompd_runtime_entry_points.tex", "ompd/ompd_third_party_tool_interface_routines.tex"])

# These type definitions are used in other definitions and must be placed at the beginning of the header file
important = ["typedef void \(\*ompt_interface_fn_t\)",
             "typedef union ompt_data_t",
             "typedef struct ompt_frame_t",
             "typedef void \(\*ompt_callback_t\)",
             "typedef void ompt_device_t",
             "typedef void ompt_buffer_t",
             "typedef void \(\*ompt_callback_buffer_request_t\)",
             "typedef void \(\*ompt_callback_buffer_complete_t\)",
             "typedef void \(\*ompt_finalize_t\)",
             "typedef int \(\*ompt_initialize_t\)",
             ]

last = ["typedef struct ompt_record_ompt_t", "typedef ompt_record_ompt_t \*\(\*ompt_get_record_ompt_t\)"]
# Read all files
content = ""
for path in paths:
  with open("../../tool_support/"+path) as file:
    content+=file.read()

splitted = content.split("{ccppspecific}");
defs = [splitt for i,splitt in enumerate(splitted) if i%2 == 1 and re.search("begin{omp", splitt) != None]

# Remove unwanted parts
for i,deff in enumerate(defs):
  deff = re.sub(r"^.*\\begin{[^}]*}", "", deff, flags=re.DOTALL)
  defs[i] = re.sub(r"\\end.*$", "", deff, flags=re.DOTALL)

# Split into the definitions that must come first and the remaining ones 
enum_defs = list(filter(lambda x: re.search("typedef (enum|uint64_t)", x) != None, defs))
first_defs = [filter(lambda x: re.search(i, x) != None, defs)[0] for i in important]
last_defs = [filter(lambda x: re.search(i, x) != None, defs)[0] for i in last] 
rem_defs = [d for d in defs if d not in first_defs and d not in enum_defs and d not in last_defs]

defs = "\n".join(enum_defs+first_defs+rem_defs+last_defs)

defs += """
#define ompt_id_none 0
#define ompt_data_none {0}
#define ompt_time_none 0
#define ompt_hwid_none 0
#define ompt_addr_none ~0
#define ompt_mutex_impl_none 0
#define ompt_wait_id_none 0

#define ompd_segment_none 0
"""

# Remove unwanted parts and newlines
defs = re.sub(r"\\plc{([^}]*)}", r"\1", defs)
defs = re.sub(r"\n\n\n", "\n\n", defs)
defs = re.sub(r"^\n", "", defs)

# Write to file
with open("omp-tools.h", "w+") as file:
  file.write(str(defs))
