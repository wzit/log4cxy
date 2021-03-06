# ===========================
# Final binary
# ===========================
LOG4CXY = log4cxy


# ===========================
# Sources & objects
# ===========================
SRC_DIR = src
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)

OBJ_DIR = obj
OBJECTS = $(addprefix $(OBJ_DIR)/,$(patsubst %.cpp,%.o,$(notdir $(SOURCES))))


# ===========================
# C++ compiler & linker flags
# ===========================
CXX_WARNINGS   = -pedantic -Wall -Werror
DEBUG_FLAGS    = -g -fno-omit-frame-pointer
OPTIMIZE_FLAGS = -O3

CXX_FLAGS      = -MMD -pthread -D_GLIBCXX_USE_NANOSLEEP -c -fmessage-length=0 -std=c++11 \
	         $(CXX_WARNINGS) \
	         $(DEBUG_FLAGS) \
	         $(OPTIMIZE_FLAGS)

LINK_FLAGS     = -pthread -lboost_program_options $(DEBUG_FLAGS)
# ===========================

# ===========================
# Run arguments
# ===========================
RUN_NUM_THREADS        = 24
RUN_THREAD_TTL         = 10
RUN_THREAD_START_DELAY = 1
RUN_ARGS               = --num-threads $(RUN_NUM_THREADS) \
                         --time $(RUN_THREAD_TTL) \
                         --delay $(RUN_THREAD_START_DELAY)

# ===========================
# Make targets
# ===========================

.PHONY: all clean run

all: $(LOG4CXY)
clean:
	rm -rfv $(OBJ_DIR) {$(LOG4CXY),$(LOG4CXY).exe} *.log *.prof

run: $(LOG4CXY)
	./$(LOG4CXY) $(RUN_ARGS)

$(LOG4CXY): $(OBJECTS) Makefile
	g++ $(OBJECTS) $(LINK_FLAGS) -o $@

VPATH = $(SRC_DIR)
$(OBJ_DIR)/%.o: %.cpp Makefile
	@test -d $(OBJ_DIR) || mkdir -v $(OBJ_DIR)
	g++ $(CXX_FLAGS) $< -o $@

include $(wildcard $(OBJ_DIR)/*.d)
include profile.inc.mk
	