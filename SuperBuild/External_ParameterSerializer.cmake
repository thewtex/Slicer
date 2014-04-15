
set( proj ParameterSerializer )

# Set dependency list
set(${proj}_DEPENDENCIES ${ITK_EXTERNAL_NAME} "JsonCpp")

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(NOT DEFINED ${proj}_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  if(NOT DEFINED git_protocol)
    set(git_protocol "git")
  endif()

  ExternalProject_Add( ${proj}
    ${${proj}_EP_ARGS}
    GIT_REPOSITORY ${git_protocol}://github.com/TubeTK/TubeTK-ParameterSerializer.git
    GIT_TAG fe360ce153bfe4efc36b276750d4606bb1d7b156
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${proj}-build
    CMAKE_CACHE_ARGS
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags} # Unused
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DITK_DIR:PATH=${ITK_DIR}
      -DJsonCpp_DIR:PATH=${JsonCpp_DIR}
    INSTALL_COMMAND ""
    DEPENDS
      ${${proj}_DEPENDENCIES} )
  set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

else()
  find_package( ${proj} REQUIRED )
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

mark_as_superbuild(
  VARS ParameterSerializer_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
