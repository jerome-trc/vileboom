if(UNIX AND NOT APPLE)
    install(FILES nyan-doom.desktop DESTINATION share/applications)
    install(FILES nyan-doom.svg DESTINATION share/icons/hicolor/scalable/apps)
endif()
