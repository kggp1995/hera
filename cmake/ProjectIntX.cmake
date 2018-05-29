if(ProjectIntXIncluded)
	return()
endif()

set(ProjectIntXIncluded TRUE)

include(ExternalProject)
include(GNUInstallDirs)

set(prefix ${CMAKE_BINARY_DIR}/deps)
set(source_dir ${prefix}/src/intx)
set(binary_dir ${prefix}/src/intx-build)

set(intx_include_dir ${source_dir}/include/intx)
set(intx_lib ${binary_dir}/libs/intx/libintx.a)

set(patch_command sed -i -e "$ d" ${source_dir}/CMakeLists.txt)
set(build_command cmake --build <BINARY_DIR>)
set(install_command cmake --build <BINARY_DIR> && cp ${intx_lib} <INSTALL_DIR>)

ExternalProject_Add(IntX
	PREFIX ${prefix}
	GIT_REPOSITORY https://github.com/chfast/intx.git
	GIT_TAG 852f43c8f18757938b99b2e5b372ccfb64a47bc2
	CMAKE_ARGS
	-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
	SOURCE_DIR ${source_dir}
	BINARY_DIR ${binary_dir}
	PATCH_COMMAND ${patch_command}
	BUILD_COMMAND ${build_command}
	INSTALL_COMMAND ${install_command}
	INSTALL_DIR ${prefix}/${CMAKE_INSTALL_LIBDIR}
	BUILD_BYPRODUCTS ${intx_lib}
)

add_library(intx::libintx STATIC IMPORTED)

set_target_properties(
	intx::libintx
	PROPERTIES
	IMPORTED_LOCATION_RELEASE ${intx_lib}
	INTERFACE_INCLUDE_DIRECTORIES ${intx_include_dir}
	INTERFACE_LINK_LIBRARIES ${intx_lib}
)

add_dependencies(intx::libintx IntX)